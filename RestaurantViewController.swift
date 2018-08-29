//
//  RestaurantViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/24/17.
//  Copyright © Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class RestaurantViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var preference: String?
    var name: String?
    var rating: Double?
    var price: Double?
    var address: String?
    var placeID: String?
    var long: Double?
    var lat: Double?
    var phone: String?
    var website: String?
    
    var num = 10
    
    var overlay: UIView?
    var loadingLabel: UILabel?
    
    var user: User?
    
    let locationManager = CLLocationManager()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var litFactorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eatHereButton: UIButton!
    @IBOutlet weak var phoneButtonLabel: UIButton!
    @IBOutlet weak var websiteButtonLabel: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchAllItems()
        var litFactor = ""
        if num > 0 {
            for _ in 0..<(10-num) {
                litFactor += "🌚"
            }
            for _ in 0..<num {
                litFactor += "🌝"
            }
            litFactorLabel.text = litFactor
        }
        
        self.becomeFirstResponder()
        
        // styling button
        eatHereButton.backgroundColor = UIColor(red: 1, green: 0.77, blue: 0.24, alpha: 1.0)
        eatHereButton.layer.cornerRadius = 20
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        let allOverlays = mapView.overlays
        mapView.removeOverlays(allOverlays)
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.white
        loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        loadingLabel?.center = CGPoint(x: (self.overlay?.bounds.size.width)! / 2 , y: (self.overlay?.bounds.size.height)! / 2)
        loadingLabel?.textAlignment = .center
        loadingLabel?.text = "Loading..."
        self.overlay?.addSubview(loadingLabel!)
        view.addSubview(overlay!)
        if preference == "Any" {
            preference = ""
        }
        
        RestaurantModel.getAllRestaurants(lat: Double(locationManager.location!.coordinate.latitude), long: Double(locationManager.location!.coordinate.longitude), preference: preference!, completionHandler: {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] as? NSArray {
                        let randomNum = Int(arc4random_uniform(UInt32(30)))
                        let result = results[randomNum] as! NSDictionary
                        self.placeID = result["place_id"] as? String
                        RestaurantModel.getRestaurantWithID(id: self.placeID!, completionHandler: {
                            data, response, error in
                            do {
                                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                    if let restaurant = jsonResult["result"] as? NSDictionary {
                                        self.name = restaurant["name"] as? String
                                        self.rating = restaurant["rating"] as? Double
                                        self.price = restaurant["price_level"] as? Double
                                        self.address = restaurant["formatted_address"] as? String
                                        let geometry = restaurant["geometry"] as! NSDictionary
                                        let location = geometry["location"] as! NSDictionary
                                        self.lat = location["lat"] as? Double
                                        self.long = location["lng"] as? Double
                                        self.phone = restaurant["formatted_phone_number"] as? String
                                        self.website = restaurant["website"] as? String
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.nameLabel.text = self.name
                                    self.ratingLabel.text = "\(self.rating!)"
                                    if self.rating! > 3.9 {
                                        self.ratingLabel.textColor = UIColor.green
                                    } else if self.rating! > 2.5 {
                                        self.ratingLabel.textColor = UIColor.orange
                                    } else {
                                        self.ratingLabel.textColor = UIColor.red
                                    }
                                    var priceLabelText = "Price: "
                                    if let numDollarSigns = self.price {
                                        for _ in 0..<Int(numDollarSigns) {
                                            priceLabelText += "💰"
                                        }
                                    } else {
                                        priceLabelText += "not listed"
                                    }
                                    self.priceLevelLabel.text = priceLabelText
                                    self.addressLabel.text = self.address!
                                    self.phoneButtonLabel.setTitle(self.phone, for: UIControlState.normal)
                                    self.createRoute(restaurantCoordinate: CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!))
                                    self.overlay?.removeFromSuperview()
                                }
                            } catch {
                                print("something went wrong")
                            }
                        })
                    }
                }

            } catch {
                print("something went wrong")
            }
        })
    }
    
    @IBAction func eatButtonPressed(_ sender: UIButton) {
        
        let historyEntry = NSEntityDescription.insertNewObject(forEntityName: "History", into: managedObjectContext) as! History
        historyEntry.name = self.name
        historyEntry.place_id = self.placeID
        
        user?.totalScore += Int32(num)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        UserModel.editUser(score: num, completionHandler: {
            data, response, error in
            
            do {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToMainSegue", sender: self)
                }
            }
        })
        
        
    }

    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMainSegue", sender: self)
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if num > 0 {
                num -= 1
            }
            viewDidLoad()
        }
    }
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        if let phoneNum = self.phone {
            callNumber(phoneNumber: phoneNum)
        }
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        if let websiteUrl = self.website {
            UIApplication.shared.open(NSURL(string: websiteUrl)! as URL, options: [:], completionHandler: nil)
        }
    }
    
    func callNumber(phoneNumber:String) {
        
        let formattedPhoneNumber = String(phoneNumber.characters.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        
        if let phoneCallURL = URL(string: "tel://\(formattedPhoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}


// MAPKIT
extension RestaurantViewController {

    func getDirections(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourceLocation = sourceCoordinate
        let destinationLocation = destinationCoordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation ()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation ()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate{
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            print("function got past error control")
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
        
        if sourceCoordinate.latitude == locationManager.location!.coordinate.latitude && sourceCoordinate.longitude == locationManager.location!.coordinate.longitude {
            self.mapView.showAnnotations([destinationAnnotation], animated: true)
        } else {
            self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        }
    }
    
    func createRoute(restaurantCoordinate: CLLocationCoordinate2D) {
        getDirections(sourceCoordinate: locationManager.location!.coordinate, destinationCoordinate: restaurantCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
        
    }
}


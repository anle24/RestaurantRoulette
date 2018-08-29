//
//  PastPlacesViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/25/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit
import CoreData

class PastPlacesViewController: UITableViewController {

    var places = [History]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        fetchAllItems()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name!
        return cell
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // core data request
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        do {
            let result = try managedObjectContext.fetch(request)
            places = result as! [History]
        } catch {
            print("\(error)")
        }
    }

    
}

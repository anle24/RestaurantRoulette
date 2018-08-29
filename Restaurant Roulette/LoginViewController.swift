//
//  ViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/25/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let usernameString = usernameInputField.text, let passwordString = passwordInputField.text{
            UserModel.loginUser(username: usernameString, password: passwordString, completionHandler: {
                data, response, error in
                
                if data != nil {
                    do{
//                        let user = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "mainPageSegue", sender: self)
                        }
                        
                    } catch {
                        print(error)
                        
                    }
                } else {
                    print("login unsuccessful")
                }
            })
        }
//        performSegue(withIdentifier: "mainPageSegue", sender: sender)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}


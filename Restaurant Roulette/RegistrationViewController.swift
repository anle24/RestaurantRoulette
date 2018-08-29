//
//  RegistrationViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/25/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var usernameInputField: UITextField!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var confirmpwInputField: UITextField!
    @IBOutlet weak var bgImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage.layer.zPosition = -1;
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if passwordInputField.text == confirmpwInputField.text {
            if let username = usernameInputField.text, let email = emailInputField.text, let password = passwordInputField.text {
                UserModel.addUser(username: username, email: email, password: password, completionHandler: {data, response, error in
                    return
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

//
//  MainPageViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/24/17.
//  Copyright © Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit
import CoreData

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eatButton.layer.cornerRadius = 20
        pastButton.layer.cornerRadius = 20
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {}
    
    
}

//
//  PreferenceViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/24/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit

class PreferenceViewController: UITableViewController {

    let preferences = ["Any", "American", "Chinese", "Italian", "Japanese", "Korean", "Mexican", "Thai", "Vietnamese"]
    
    let preferencesText = ["🚨   Any   🚨", "🇺🇸   American   🇺🇸", "🇨🇳   Chinese   🇨🇳", "🇮🇹   Italian   🇮🇹", "🇯🇵   Japanese   🇯🇵", "🇰🇷   Korean   🇰🇷", "🇲🇽   Mexican   🇲🇽", "🇹🇭   Thai   🇹🇭", "🇻🇳   Vietnamese   🇻🇳"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath) as! PreferenceCell
        cell.preferenceLabel.text = preferencesText[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurantSegue" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! RestaurantViewController
            let indexPath = sender as! NSIndexPath
            controller.preference = preferences[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "restaurantSegue", sender: indexPath)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    
}

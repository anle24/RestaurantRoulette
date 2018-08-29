//
//  FriendsViewController.swift
//  Restaurant Roulette
//
//  Created by Allen Fang, Harrison Mai, Alan Le, Sam Moon on 5/25/17.
//  Copyright © 2017 Allen Fang, Harrison Mai, Alan Le, Sam Moon. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {

    var friends = [String]()
    var scores = [Int]()
    var history = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        UserModel.getAllUsers(completionHandler: {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for result in jsonResult {
                        let user = result as! NSDictionary
                        self.friends.append((user["username"] as? String)!)
                        self.scores.append((user["score"] as? Int)!)
                        let historyArrray = user["history"] as? NSArray
                        self.history.append(historyArrray!.count + 1)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("didn't work")
            }
        })
        
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(friends.count)
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        cell.textLabel?.text = "\(friends[indexPath.row]) - Score: \(scores[indexPath.row] / history[indexPath.row]) "
        return cell
    }
    
}

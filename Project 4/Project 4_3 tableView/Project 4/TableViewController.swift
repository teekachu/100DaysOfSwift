//
//  TableViewController.swift
//  Project 4_3
//
//  Created by Ting Becker on 5/16/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var website = ["google","apple","hackingwithswift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return website.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sites", for: indexPath)
        cell.textLabel?.text = website[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? ViewController {
            vc.selectedSite = website[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

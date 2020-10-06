//
//  ViewController.swift
//  Cons_Project#1
//
//  Created by Ting Becker on 5/6/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " Flag Photos"
/*      let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try!fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasSuffix("3x.png") {
                flags.append(item)
            }
        }
 */
        flags += ["nigeria","spain","italy","germany","ireland",
        "estonia","russia", "poland","uk","us","france","monaco"]
        flags.sort()
        
        print(flags)
    }
    
    override func tableView(_ tableview: UITableView, numberOfRowsInSection: Int) -> Int {
        return flags.count
    }
        
    override func tableView(_ tableview: UITableView , cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row].uppercased()
        return cell
        
            
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailPic") as? DetailViewController {
        vc.selectedImage = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        
    }
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.flags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    
    
    }





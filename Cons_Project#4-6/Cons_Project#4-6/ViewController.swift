//
//  ViewController.swift
//  Cons_Project#4-6
//
//  Created by Ting Becker on 6/15/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allItems = [String]() // to hold the total list
//    var usedItems = [String]() //to prevent duplicate items in list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear List", style: .plain, target: self, action: #selector(startList))
        
        let add = UIBarButtonItem(title: "Add Item", style: .plain, target: self, action: #selector(addItem))
        
        let shareList = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareOnTapped))
        
        navigationItem.rightBarButtonItems = [add, shareList]
        navigationController?.isToolbarHidden = false
        
        startList()
        // Do any additional setup after loading the view.
    }
    

    @objc func startList() {
        title = "My Shopping List"
        allItems.removeAll(keepingCapacity: false)
        tableView.reloadData() // freshlist for everytime the project starts
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = allItems[indexPath.row]
        return cell
    }
    
    @objc func addItem(){
        let ac = UIAlertController(title: "Adding item to list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    //conditions to add
    func isNotBlank(word: String) -> Bool {
        return !word.isEmpty
    }
    
    func isNotDuplicate(word: String) -> Bool{
        return !allItems.contains(word)
    }
    
    func submit(_ answer: String){ // insert this into rows of tableview
    
        let lowercaseItem = answer.lowercased()
        
        //check if duplicate item
        
        guard isNotBlank(word: lowercaseItem) else {
            errorMessage(title: "You can't just leave it blank", message: "Are we buying air?")
            return
        }
            
        guard isNotDuplicate(word: lowercaseItem) else {
            errorMessage(title: "You already have this item in the list.", message: "Do we need anything else?")
            return
        }
                
                allItems.insert(lowercaseItem, at: 0)
                                
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        
        
    func errorMessage(title: String, message: String){
        let errorTitle = title
        let errorMessage = message
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .cancel)
        ac.addAction(okay)
        present(ac, animated: true)

    }
        

    @objc func shareOnTapped(){
        let list = allItems.joined(separator: "\n")

        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
        
    }
    
    
}


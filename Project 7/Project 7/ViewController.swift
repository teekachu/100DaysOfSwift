//
//  ViewController.swift
//  Project 7
//
//  Created by Ting Becker on 6/17/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]() // original
    var copyOfPetitions = [Petition]() //copy of original , used to reload
    var filteredItems = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredit))
        
        let searchBttn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchForKeyWord))
        
        let clearSearch = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(redoSearch))
        
        navigationItem.rightBarButtonItems = [clearSearch, searchBttn]
        
        let url : String
        if navigationController?.tabBarItem.tag == 0 {
            url = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            url = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        //new . used GCD to allocate queue for importance. push parsing to background thread
        DispatchQueue.global(qos: .userInitiated).async{
            
            if let urlString = URL(string: url){
                if let data = try? Data(contentsOf: urlString){
                    self.parse(json: data)
                    return
                }
            }
            self.showError() //now this is in background thread, go down to function to push it back to main.
            
        }//end of closure
//        showError()
        // if we put it here, gets executed regardless of result of fetch call (inside closure), so need to move in the closure
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPtitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPtitions.results
            copyOfPetitions = jsonPtitions.results
            //tableView.reloadData()
            //below because we are on a background thread and want to execute code from main thread
            DispatchQueue.main.async{ // push it back to main
                self.tableView.reloadData()
            }
        }
    }
        
    @objc func showCredit(){
        let ac = UIAlertController(title: "Credits", message: " The data within comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "okay", style: .default)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
    func showError(){ // push this back to main because alert is UI work
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            let alert = UIAlertAction(title: "Okay", style: .default)
            ac.addAction(alert)
            self.present(ac, animated: true)
        }
    }
    
    @objc func searchForKeyWord(){
        let ac = UIAlertController(title: "Enter Keyword", message: "Use keyword to search for petitions you are interested in", preferredStyle: .alert)
        ac.addTextField()
        
        let submitKeyWord = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self?.search(keyword)
        }
        
        ac.addAction(submitKeyWord)
        present(ac, animated: true)
        
    }
    
    @objc func redoSearch(){
        petitions.removeAll()
        petitions += copyOfPetitions
        tableView.reloadData()
    }
    
    func search(_ keyword: String){
        
        petitions.removeAll()
        filteredItems.removeAll()
        
        let loweranswer = keyword.lowercased()
       
        DispatchQueue.global(qos: .userInitiated).async {
            for item in self.copyOfPetitions{
            if item.title.lowercased().contains(loweranswer){
                if item.body.lowercased().contains(loweranswer){
                    self.filteredItems.append(item)
            }
        }
        }
        
            self.petitions += self.filteredItems
        
            if self.petitions.isEmpty{
                self.nothingFound()
        }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func nothingFound(){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Oops", message: "Looks like nothing can be found with this keyword, try another keyword? ", preferredStyle: .alert)
            let okay = UIAlertAction(title: "alrighty", style: .cancel)
            ac.addAction(okay)
            self.present(ac, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petitionPerCell = petitions[indexPath.row]
        cell.textLabel?.text = petitionPerCell.title
        cell.detailTextLabel?.text = petitionPerCell.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}





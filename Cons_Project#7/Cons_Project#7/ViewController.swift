//
//  ViewController.swift
//  Cons_Project#7
//
//  Created by Tee Becker on 9/30/20.
//  IOS notes project
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var notes = [eachNote]()
    var filteredNotes = [eachNote]()
    //    var notes: [(title: String, detail: String)] = []
    //    var filteredNotes: [(title: String, detail: String)] = []
    
    @IBOutlet var label: UILabel!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        MARK: USER DEFAULTS
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "allNotesSaved"){
            let jsonDecoder = JSONDecoder()
            do{
                notes = try! jsonDecoder.decode([eachNote].self, from: savedNotes as! Data)
                
                // if notes are empty - show label and hide table
                if !notes.isEmpty{
                    tableview.isHidden = false
                } else {
                    tableview.isHidden = true
                    label.isHidden = false
                }
            }
        }
        
       
        //        //        MARK: USER DEFAULTS
        //        let defaults = UserDefaults.standard
        //        if let savedNotes = defaults.object(forKey: "allNotesSaved"){
        //            let jsonDecoder = JSONDecoder()
        //            do{
        //                notes = try! jsonDecoder.decode([eachNote].self, from: savedNotes as! Data)
        //            }
        //        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        filteredNotes = notes
        
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        
        let createNewNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [flexibleSpace, createNewNote]
        navigationController?.isToolbarHidden = false
        // Do any additional setup after loading the view.
        
        
    }
    
    @objc func newNote(){
        //go to entryVC
        guard let entryVC = storyboard?.instantiateViewController(withIdentifier: "entryVC") as? entryViewController else{return}
        entryVC.title = "New Note"
        entryVC.completion = {[weak self] noteTitlePulled, noteDetailPulled in
            self?.notes.insert(eachNote(title: noteTitlePulled, detail: noteDetailPulled), at: 0)// insert the notes pulled into array at 0 index
            self?.filteredNotes.insert(eachNote(title: noteTitlePulled, detail: noteDetailPulled), at: 0)
            
            
            //            self.notes.insert((title: noteTitlePulled, detail: noteDetailPulled), at: 0)
            //            self.filteredNotes.insert((title: noteTitlePulled, detail: noteDetailPulled), at: 0)
            
            self?.navigationController?.popToRootViewController(animated: true)
            
            //unhide tableview and hide the label
            self?.tableview.isHidden = false
            self?.label.isHidden = true
            
            // MARK: save note
            self?.save()
            
            //reload data
            self?.tableview.reloadData()
        }
        
        navigationController?.pushViewController(entryVC, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "allNotesSaved")
        } else{
            print("unable to save data")
        }
    }
    
    //MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredNotes[indexPath.row].title
        cell.detailTextLabel?.text = filteredNotes[indexPath.row].detail
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let noteVC = storyboard?.instantiateViewController(withIdentifier: "noteVC") as? noteViewController{
            noteVC.title = "Note"
            
            noteVC.titleToLoad = notes[indexPath.row].title
            noteVC.detailToLoad = notes[indexPath.row].detail
            
            navigationController?.pushViewController(noteVC, animated: true)
        }
        
    }
    
    //MARK: SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // first set the filteredNotes to blank.
        // if searchText is empty, then filtered notes is till notes, if not, then we filter notes for searchText's texts and see if any matches
        
        filteredNotes = []
        filteredNotes = searchText.isEmpty ? notes : notes.filter({ (eachNote) -> Bool in
            eachNote.title.lowercased().contains(searchText.lowercased()) ||
                eachNote.detail.lowercased().contains(searchText.lowercased())
        })
        
        
        //        filteredNotes = searchText.isEmpty ? notes : notes.filter({ (title: String, detail: String) -> Bool in return
        //
        //            title.lowercased().contains(searchText.lowercased()) ||
        //                detail.lowercased().contains(searchText.lowercased())
        //
        //        })
        
        save()
        tableview.reloadData()
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}


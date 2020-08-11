//
//  TableViewController.swift
//  Project 5
//
//  Created by Ting Becker on 5/28/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var score = 0
    var currentWord = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add bar button items
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "REFRESH", style: .plain, target: self, action: #selector(refresh))
        let add = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(promptForAnswer))
        let points = UIBarButtonItem(title: "SCORE", style: .plain, target: self, action: #selector(myScore))
        
        //        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(startGame) )
        
        //        let answer = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        //        let score = UIBarButtonItem.init(barButtonSystemItem: .play
        //            , target: self, action: #selector(myScore))
        
        navigationItem.rightBarButtonItems = [ add, points ]
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            //find file based on name and extensionName
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                //load file to turn texts into string by creating string instance from the filepath
                if let startWords = try? String(contentsOf: startWordsURL) { //split words by "\n" which is already in text file
                    self.allWords = startWords.components(separatedBy: "\n")
                }
            }
            if self.allWords.isEmpty {
                self.allWords = ["silkworm"]
            }
            
            self.startGame()
        }
        
        let defaults = UserDefaults.standard
        
        if let savedWords = defaults.object(forKey: "usedWords") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do{
                usedWords = try jsonDecoder.decode([String].self, from: savedWords)
            } catch {
                print("It failed to load usedWords ")
            }
        }
        
        if let savedtitle = defaults.object(forKey: "savedTitle") as? Data{
            let jsonDecoder = JSONDecoder()
            
            do{
                currentWord = try jsonDecoder.decode(String.self, from: savedtitle)
            } catch {
                print("unable to load title")
            }
        }
        
        if let savedScore = defaults.object(forKey: "savedScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do{
                score = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("unable to load score")
            }
            
        }
        // end of viewDidLoad
    }
    
    @objc func startGame() {
        DispatchQueue.main.async {
            //            self.currentWord = self.allWords.randomElement() ?? "abracadabra"
            self.title = self.currentWord

            self.save()
            //            self.usedWords.removeAll(keepingCapacity: true)
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh(){
        currentWord = allWords.randomElement() ?? "abracadabra"
        title = currentWord
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    //prompt for answer function below ( includng closure )
    @objc func promptForAnswer () {
        let ac = UIAlertController(title: "Enter Answer below", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer) //calling the submit function on the bottom
        }
        
        ac.addAction(submitAction) // add alert action into alert controller
        present(ac, animated: true)
    }
    
    
    //condition1
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    //condition2
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    //condition3
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    //condition4
    func islongEnough(word: String) -> Bool {
        
        if word.count <= 3 {
            return false
        }
        return true
    }
    
    func submit(_ answer: String) {
        
        let lowerAnswer = answer.lowercased()
        guard let chosenWord = title?.lowercased() else { return }
        
        guard isReal(word: lowerAnswer) else {
            showErrorMessage(title: "word not recognized", message: "you can't just make them up, you know...")
            return
        }
        guard isOriginal(word: lowerAnswer) else {
            showErrorMessage(title: "word used already", message: "Be more original")
            return
        }
        guard islongEnough(word: lowerAnswer) else {
            showErrorMessage(title: "your answer is too short", message: "try an answer longer than 3 letters")
            return
        }
        
        guard isPossible(word: lowerAnswer) else {
            showErrorMessage(title: "word not possible", message: "you can't spell that word from \(chosenWord)")
            return
        }
        
        usedWords.insert(answer.lowercased(), at: 0)
        score += 1
        save()
        let indexpath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexpath], with: .automatic)
        
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(usedWords){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "usedWords")
        } else{
            print("It failed to save usedWords ")
        }
        
        if let savedTitle = try? jsonEncoder.encode(currentWord){
            let defaults = UserDefaults.standard
            defaults.set(savedTitle, forKey:"savedTitle")
        } else{
            print("unable to save title")
        }
        
        if let savedScore = try? jsonEncoder.encode(score) {
            let defaults = UserDefaults.standard
            defaults.set(savedScore, forKey: "savedScore")
        } else {
            print("unable to save score")
        }
        
    }
    
    @objc func myScore () {
        let ac = UIAlertController (title: "Current Score", message: "Your Score is \(score)", preferredStyle: .alert)
        let readAction = UIAlertAction(title: "Got it", style: .cancel)
        ac.addAction(readAction)
        present(ac, animated: true)
    }
    
    func showErrorMessage(title: String, message: String ){
        let errorTitle = title
        let errorMessage = message
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
}



//    func submit (_ answer: String) {
//        let lowerAnswer = answer.lowercased()
//
//        let errorTitle: String
//        let errorMessage: String
//
//        if isPossible(word: lowerAnswer) {
//            if isReal(word: lowerAnswer) {
//                if isOriginal(word: lowerAnswer) {
//                    if islongEnough(word: lowerAnswer) {
//
//                        usedWords.insert(answer, at: 0)
//                        score += 1
//
//                        let indexPath = IndexPath(row: 0, section: 0)
//                        tableView.insertRows(at: [indexPath], with: .automatic)
//
//                        return
//
//                    } else {
//                        errorTitle = " Your Word is Too Short "
//                        errorMessage = " Try a word longer than 3 letters.. please"
//                    }
//                } else {
//                    errorTitle = "Word used already"
//                    errorMessage = "Be more original"
//            }
//            } else {
//                errorTitle = "Word not recognized"
//                errorMessage = "You can't just make them up, you know.. "
//        }
//        } else {
//            guard let title = title?.lowercased() else { return }
//            errorTitle = "Word not possible"
//            errorMessage = "You can't spell that word from \(title)... come on"
//        }
//
//        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "ok", style: .default))
//        present(ac, animated: true)
//
//    }
//
//

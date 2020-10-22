//
//  ViewController.swift
//  Cons_Proj # 7-9
//
//  Created by Ting Becker on 6/27/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let lifeLabel = TBLabel(fontsize: 25)
    var life = 7{
        didSet{
            lifeLabel.text = "Life remaining: \(life)"}}
    let scoreLabel = TBLabel(fontsize: 25)
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"}}
    let cluesLabel = TBLabel(fontsize: 40)
    let textFieldToGuess = TBTextField(fontsize: 25)
    let submit = TBButton(title: "Submit", fontsize: 25)
    let clear = TBButton(title: "Clear", fontsize: 25)
    let buttonsview = TBButtonsView()
    var letterBits = [UIButton]()
    
    var buttonTapped = [UIButton]() // only contain 1 button
    var letterButtonUsed = [UIButton]()
    
    var wordInUse = ""
    var lettersCountInWord = ""
    var usedLetters = [String]()
    var allWords = [String]()
    var usedWords = [String]()
    let padding: CGFloat = 10
    var wordCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        topLayoutUI()
        middleLayoutUI()
        bottomLayoutUI()
        configureButtonsInButtonsView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLevel()
        }
    }
    
    
    func configureView(){
        view.addSubview(lifeLabel)
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(textFieldToGuess)
        view.addSubview(submit)
        view.addSubview(clear)
        view.addSubview(buttonsview)
    }
    
    
    @objc func letterTapped(_ Sender: UIButton){
        buttonTapped.removeAll()
        textFieldToGuess.text = Sender.titleLabel?.text
        buttonTapped.append(Sender)
    }
    
    
    @objc func clearTapped(_ Sender: UIButton) {
        if !buttonTapped.isEmpty{
            textFieldToGuess.text = ""
            buttonTapped.removeAll()
        }
    }
    
    //*** UPDATE BELOW ***
    @objc func submitTapped(_ Sender: UIButton){
        letterButtonUsed.append(contentsOf: buttonTapped)
        buttonTapped.removeAll()
        
        // lettersCountInWord is the text that will show in cluesLabel example: (eat) -> ??? -> ea?
        lettersCountInWord.removeAll()
        // pull the letter from textfield, add it to usedLetters
        guard let singleLetter = textFieldToGuess.text else { return }
        usedLetters.append(singleLetter)
        
        // check to see if the word contains this letter, + or - points accordingly
        if !wordInUse.contains(singleLetter){
            life -= 1
        } else{
            score += 1
        }
        
        // change lettersCountInWord text using a forloop. Not the best way to do this but works.
        for letter in wordInUse {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter){
                lettersCountInWord += strLetter
            } else {
                lettersCountInWord += "?"
            }
        }
        // set the textlabel text to be the new lettersCountInWord text
        self.cluesLabel.text = lettersCountInWord
        
        // hide the button
        for button in letterButtonUsed{
            button.isHidden = true
        }
        //clear clues field
        textFieldToGuess.text = ""
        
        // go to the next  word
        if cluesLabel.text == wordInUse {
            moveToNextWord()
        }
    }
    
    func moveToNextWord(){
        let ac = UIAlertController(title: "GOOD JOB", message: "ready for the next word? ", preferredStyle: .alert)
        let action = UIAlertAction(title: "LetsssGo", style: .default, handler: nextWord)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @objc func nextWord (_ action: UIAlertAction){
        
        if usedWords == allWords{
            passedGame()
        } else {
            wordCount += 1
            usedWords.append(wordInUse)  //add word to usedWords list
            usedLetters.removeAll()   // remove all the usedLetters to start fresh
            for each in letterButtonUsed{
                each.isHidden = false } //unhide all the buttons that were hidden}
            letterButtonUsed.removeAll()  // remove everything in letterButtonUsed
            lettersCountInWord.removeAll()
            textFieldToGuess.text = ""
            wordInUse = ""
            loadLevel()
        }
    }
    
    func loadLevel(){
        
        var allLetters = [String]()
        guard let file = Bundle.main.url(forResource: "Letters", withExtension: "txt") else { return }
        guard let fileContent = try? String(contentsOf: file) else {return}
        var lines = fileContent.components(separatedBy: "\n")
        lines = lines.filter{ $0 != "" }
        allLetters += lines
        
        DispatchQueue.main.async {
            if self.letterBits.count == allLetters.count{
                for i in 0..<self.letterBits.count {
                    //TODO: code to put letters inside each letter button
                    self.letterBits[i].setTitle(allLetters[i], for: .normal)
                }
            }
        }
        guard let wordsFile = Bundle.main.url(forResource: "Words", withExtension: "txt") else { return }
        guard let wordsString = try? String(contentsOf: wordsFile) else { return }
        allWords = wordsString.components(separatedBy: "\n")
        allWords = allWords.filter {$0 != ""}
        
        DispatchQueue.main.async {
            let chosenWord = self.allWords[self.wordCount] // chosenWord is always the first [0]
            for _ in 1 ... chosenWord.count{
                self.lettersCountInWord.append("?") // cluesLabel
            }
            self.cluesLabel.text = self.lettersCountInWord
            self.wordInUse.append(chosenWord)
            self.textFieldToGuess.placeholder = "\(self.wordInUse.count) letters"  // 10 letters
            
            print(self.allWords)
            print(self.wordInUse)
            print(self.usedWords)
            print(self.allWords.count)
        }//end of GCD
    }
    
    func passedGame (){
        let ac = UIAlertController(title: "GOODJOB", message: "You beat the game", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cool", style: .cancel)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    //MARK: UI Stuff
    
    func configureButtonsInButtonsView(){
        let width:CGFloat = 91
        let height:CGFloat = 60
        
        for column in  0 ..< 9 {
            for row in 0 ..< 3 {
                //create one letterButton
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle("A", for: .normal)
                letterButton.tintColor = .systemTeal
                letterButton.layer.cornerRadius = 15
                letterButton.layer.borderWidth = 2
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: CGFloat(column) * width, y: CGFloat(row) * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsview.addSubview(letterButton)
                letterBits.append(letterButton)
            }
        }
    }
    
    
    func topLayoutUI(){
        lifeLabel.text = "Life remaining: 7"
        scoreLabel.text = "Score: 0"
        
        NSLayoutConstraint.activate([
            lifeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            lifeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            lifeLabel.heightAnchor.constraint(equalToConstant: 28),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            scoreLabel.heightAnchor.constraint(equalTo: lifeLabel.heightAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: padding),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            cluesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            cluesLabel.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor),
            
            textFieldToGuess.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            textFieldToGuess.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: padding),
            textFieldToGuess.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
    
    func middleLayoutUI(){
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo: textFieldToGuess.bottomAnchor, constant: padding),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.topAnchor.constraint(equalTo: textFieldToGuess.bottomAnchor, constant: padding),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor)
        ])
    }
    
    
    func bottomLayoutUI(){
        
        NSLayoutConstraint.activate([
            buttonsview.topAnchor.constraint(equalTo: clear.bottomAnchor, constant: padding),
            buttonsview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            buttonsview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonsview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
}


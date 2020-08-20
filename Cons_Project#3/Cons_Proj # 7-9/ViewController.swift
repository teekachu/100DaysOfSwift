//
//  ViewController.swift
//  Cons_Proj # 7-9
//
//  Created by Ting Becker on 6/27/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var lifeLabel: UILabel!
    var life = 7{
        didSet{
            lifeLabel.text = "Life remaining: \(life)"
            //alert
        }
    }
    var scoreLabel: UILabel!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
            //alert
        }
    }
    var cluesLabel: UILabel!
    var textFieldToGuess: UITextField!
    var letterBits = [UIButton]()
    var letterButtonUsed = [UIButton]()
    var wordInUse = ""
    var lettersCountInWord = ""
    var usedLetters = [String]()
    var allWords = [String]()
    var usedWords = [String]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .lightGray
        
        lifeLabel = UILabel()
        lifeLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        lifeLabel.text = "Life remaining: 7"
        lifeLabel.font = UIFont.systemFont(ofSize: 25)
        lifeLabel.textColor = .black
        //        lifeLabel.backgroundColor = .white
        view.addSubview(lifeLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 25)
        scoreLabel.textColor = .black
        //        scoreLabel.backgroundColor = .white
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        //        cluesLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        cluesLabel.textAlignment = .center
        cluesLabel.text = "clues ... PLACEHOLDER"
        cluesLabel.font = UIFont.systemFont(ofSize: 40)
        cluesLabel.textColor = .white
        //        cluesLabel.backgroundColor = .black
        view.addSubview(cluesLabel)
        
        textFieldToGuess = UITextField()
        textFieldToGuess.translatesAutoresizingMaskIntoConstraints = false
        textFieldToGuess.isUserInteractionEnabled = false
        //        textFieldToGuess.placeholder = "TYPE LETTERS TO GUESS"
        textFieldToGuess.textAlignment = .center
        textFieldToGuess.font = UIFont.systemFont(ofSize: 30)
        //        textFieldToGuess.backgroundColor = .white
        textFieldToGuess.tintColor = .yellow
        textFieldToGuess.textColor = .black
        view.addSubview(textFieldToGuess)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.setTitle("submit", for: .normal)
        //        submit.backgroundColor = .white
        submit.setTitleColor(.black, for: .normal)
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.setTitle("clear", for: .normal)
        //        clear.backgroundColor = .white
        clear.setTitleColor(.black, for: .normal)
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //        buttonsView.backgroundColor = .white
        view.addSubview(buttonsView)
        
        //      REASON why didnt create the individual letter bit here is because we need it in the loop to create multiple ones.
        
        
        NSLayoutConstraint.activate([
            lifeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            lifeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            //            lifeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            //            scoreLabel.heightAnchor.constraint(equalTo: lifeLabel.heightAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            cluesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            cluesLabel.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor),
            
            textFieldToGuess.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            textFieldToGuess.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 10),
            textFieldToGuess.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            //            textFieldToGuess.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            //            textFieldToGuess.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            
            submit.topAnchor.constraint(equalTo: textFieldToGuess.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            submit.heightAnchor.constraint(equalToConstant: 40),
            
            clear.topAnchor.constraint(equalTo: textFieldToGuess.bottomAnchor, constant: 20),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor, multiplier: 1),
            
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: clear.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10),
        ])
        
        let width = 83
        let height = 55
        
        for column in 0 ..< 9 {
            for row in 0 ..< 3 {
                
                //create one letterButton as an example
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle("A", for: .normal)
                //                letterButton.backgroundColor = .systemPink
                letterButton.setTitleColor(.black, for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterBits.append(letterButton)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLevel()
        }

    }
    
    @objc func letterTapped(_ Sender: UIButton){
        if let textInButton = Sender.titleLabel?.text{
            textFieldToGuess.text = textInButton
        }
    }
    
    @objc func clearTapped(_ Sender: UIButton) {
        textFieldToGuess.text = ""
    }
    
    //*** UPDATE BELOW ***
    
    @objc func submitTapped(_ Sender: UIButton){
        
        lettersCountInWord.removeAll()

        guard let singleLetter = textFieldToGuess.text else { return }
        usedLetters.append(singleLetter)

        for letter in wordInUse {

            let strLetter = String(letter)

            if usedLetters.contains(strLetter){
                lettersCountInWord += strLetter
            } else {
                lettersCountInWord += "_ "
            }
            
        }

        self.cluesLabel.text = lettersCountInWord

        for button in letterButtonUsed{
            button.isHidden = true
        }

        if cluesLabel.text == wordInUse {
            
            //code to jump into next word.
            let ac = UIAlertController(title: "GOOD JOB", message: "ready for the next word? ", preferredStyle: .alert)
            let action = UIAlertAction(title: "LetsssGo", style: .default, handler: nextWord)
            ac.addAction(action)
            present(ac, animated: true)
        }
    }
    
    @objc func nextWord (_ action: UIAlertAction){
        
        if usedWords == allWords{
            passedGame()
        } else {
        usedWords.append(wordInUse)
        usedLetters.removeAll()
        textFieldToGuess.text = ""
        wordInUse = ""
        lettersCountInWord.removeAll()
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
                //                       print("Hello World")
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
        allWords.shuffle()
        
        DispatchQueue.main.async {
            let chosenWord = self.allWords[0] // chosenWord is always the first [0]
            
            for _ in 1 ... chosenWord.count{
                self.lettersCountInWord.append("_ ")
            }
            
            self.cluesLabel.text = self.lettersCountInWord
            
            self.wordInUse.append(chosenWord)
            self.textFieldToGuess.placeholder = "\(chosenWord.count) letters"
            
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
    
}


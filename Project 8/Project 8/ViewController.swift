//
//  ViewController.swift
//  Project 8
//
//  Created by Ting Becker on 6/20/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel : UILabel!
    var answerLabel : UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    //    var hiddenButtons = [UIButton]()
    
    var score = 0 {
        didSet{ //if this variable change, then change the code inside didSet
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .gray
        
        //actual code for labels and buttons
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 30)
        scoreLabel.textColor = .white
        //        scoreLabel.backgroundColor = .lightGray
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.text = "CLUES"
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.textColor = .white
        //        cluesLabel.backgroundColor = .lightGray
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.text = "ANSWERS"
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        answerLabel.textColor = .white
        //        answerLabel.backgroundColor = .lightGray
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.placeholder = "Tap Letters Below to Guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        //        currentAnswer.backgroundColor = .white
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.tintColor = .white
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.tintColor = .white
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 5
        buttonsView.layer.cornerRadius = 30
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        //        buttonsView.backgroundColor = .lightGray
        view.addSubview(buttonsView)
        
        //auto-layout below
        NSLayoutConstraint.activate([ //all constraints in array
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 30),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.widthAnchor.constraint(equalToConstant: 100),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.widthAnchor.constraint(equalToConstant: 100),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20)
            
        ])
        
        // each button
        let width = 150
        let height = 80
        
        // creating buttons as a 4(row) x 5 (column) grid
        for row in 0 ..< 4 {
            for col in 0 ..< 5 {
                //create one button as example
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("ABC", for: .normal)
                letterButton.setTitleColor(.white, for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                //calculate frame of this button using column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                //add to buttonsView
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLevel()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func letterTapped(_ Sender: UIButton){
        
        //when any letter buttons are tapped
        guard let buttonTitle = Sender.titleLabel?.text else {return}
        self.currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        self.activatedButtons.append(Sender)
        //        Sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0,options: [], animations: {
            Sender.alpha = 0
        }) { _ in
            Sender.isHidden = true
        }
    }
    
    @objc func clearTapped(_ Sender: UIButton){
        //when clear button is tapped
        currentAnswer.text = ""
        for buttons in activatedButtons{
            buttons.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    @objc func submitTapped(_ Sender: UIButton){
        //when submit button is tapped
        guard let answerText = currentAnswer.text else{return}
        guard let solutionPosition = solutions.firstIndex(of: answerText) else {
            alertWrongAnswer()
            for button in activatedButtons{
                button.isHidden = false
            }
            return
        }
        
        var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
        splitAnswers?[solutionPosition] = answerText
        answerLabel.text = splitAnswers?.joined(separator: "\n")
        
        score += 1
        activatedButtons.removeAll()
        currentAnswer.text = ""
        
        if score % 7 == 0 {
            let ac = UIAlertController(title: "Good Job", message: "Head to the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Sure, bring it on", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
        
        
        //extract the text inside (currentAnswer) and put it in (answerText), fine the position of (answerText) in the [solutions] array, remove all the buttons inside [activatedButtons] for next word.
        //Then we seperate out the texts inside (answerLabel), find the line that have the same position as (answerText) replace where it says "7 letters" with the (answerText), then join answerLabel again.
        //add 1 to score, delete current text shown in (currentAnswer)
        //if Score is 7, call nextLevel alert via alert pop up
    }
    
    func levelUp(_ action: UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        self.loadLevel() //now level should be 2
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    fileprivate func alertWrongAnswer() {
        //alert
        let ac = UIAlertController(title: "Hmm?", message: "Are you sure that is the right word?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let me try again", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                let newLines = lines.filter{ $0 != "" }
                
                for (index, line) in newLines.enumerated() {
                    
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        DispatchQueue.main.async {
            self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if letterBits.count == self.letterButtons.count {
                for i in 0 ..< self.letterButtons.count {
                    self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
}

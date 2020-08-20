//
//  ViewController.swift
//  Me_And_You
//
//  Created by Ting Becker on 6/22/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel! //score
    var letterButtons = [UIButton]()
    
    let backgroundImageView = UIImageView()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet{
            scoreLabel.text = "Brownie-Points: \(score)"
            rightAnswer()
        }
    }
    
    override func loadView() {
        view = UIView()
        setBackground()
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.text = "  Brownie-Points: 0   "
        scoreLabel.textColor = .systemPink
        scoreLabel.backgroundColor = .yellow
        scoreLabel.layer.cornerRadius = 10
        scoreLabel.layer.masksToBounds = true
        //        scoreLabel.backgroundColor = .lightGray
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 14) //TODO:change font later
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "Clues"
        cluesLabel.textColor = .white
        //        cluesLabel.backgroundColor = .lightGray
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 14) //TODO:change font later
        answersLabel.numberOfLines = 0
        answersLabel.text = "Answers"
        answersLabel.textAlignment = .right
        answersLabel.textColor = .white
        //        answersLabel.backgroundColor = .gray
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap Letters to Play"
        currentAnswer.textAlignment = .center
        currentAnswer.textColor = .white
        currentAnswer.font = UIFont.systemFont(ofSize: 25)
        currentAnswer.isUserInteractionEnabled = false // gets rid of the pop up keyboards
        //        currentAnswer.backgroundColor = .lightGray
        view.addSubview(currentAnswer)
        
        let submit = UIButton()
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        //        submit.backgroundColor = . lightGray
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton()
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        //        clear.backgroundColor = .lightGray
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        //        let reload = UIButton()
        //        reload.translatesAutoresizingMaskIntoConstraints = false
        //        reload.setTitle("Reload", for: .normal)
        //        reload.backgroundColor = .systemPink
        //        reload.setTitleColor(.yellow, for: .normal)
        //        reload.layer.cornerRadius = 10
        //        reload.addTarget(self, action: #selector(loadLevel), for: .touchUpInside)
        //        view.addSubview(reload)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //        buttonsView.backgroundColor = .white
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            //            reload.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //            reload.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0),
            cluesLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7, constant: -10),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0),
            answersLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3, constant: -10),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor, constant: 0),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            currentAnswer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 10),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 60),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor, constant: 0),
            clear.heightAnchor.constraint(equalToConstant: 60),
            
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 100),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        let width = 80
        let height = 45
        
        for row in 0..<5 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                letterButton.setTitleColor(.white, for: .normal)
                
                letterButton.setTitle("TEE", for: .normal)
                
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
            }
        }
        
    } // END OF LOADVIEW
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        let dimview = UIView()
        //        dimview.translatesAutoresizingMaskIntoConstraints = false
        //        dimview.backgroundColor = .white
        //        dimview.alpha = 0.2
        //        view.addSubview(dimview)
        //        dimview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        //        dimview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        //        dimview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        //        dimview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        
        self.loadLevel()
        
    } // END OF VIEW-DID-LOAD
    
    func setBackground(){
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.9
        
        backgroundImageView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 0).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        backgroundImageView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0).isActive = true
        
        
        backgroundImageView.image = UIImage(named: "background")
        
        view.sendSubviewToBack(backgroundImageView)
    }
    
    @objc func lettersTapped(_ Sender: UIButton){
        guard let buttonTitle = Sender.titleLabel?.text else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        
        activatedButtons.append(Sender)
        Sender.isHidden = true
    }
    
    @objc func submitTapped(_ Sender: UIButton){
        
        if score == 10 {
           alertYayGoodJob()
        }
            
            guard let wordToSubmit = currentAnswer.text else { return }
            
            guard let solutionIndex = solutions.firstIndex(of: wordToSubmit) else {
                alertWrongWord()
                return
            }
            activatedButtons.removeAll()
            
            var eachAnswer = answersLabel.text?.components(separatedBy: "\n")
            eachAnswer?[solutionIndex] = wordToSubmit
            answersLabel.text = eachAnswer?.joined(separator: "\n")
            score += 1
            currentAnswer.text = ""
        
    }
    
    
    func alertWrongWord(){
        
        let ac1 = UIAlertController(title: "Hmm", message: "Are you sure that's the right word?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Lemme try again", style: .default)
        ac1.addAction(ok)
        present(ac1, animated: true)
        
    }
    
        func alertYayGoodJob(){
    
            let ac = UIAlertController(title: "OMGG GOOD JOB !!!", message: "Wow, Look at you getting them brownie points. Thanks for being in my life, I am so lucky to have met you. ", preferredStyle: .alert)
            let alright = UIAlertAction(title: "DAMN RIGHT", style: .cancel)
            ac.addAction(alright)
            present(ac, animated: true)
        }
    
    @objc func clearTapped(_ Sender: UIButton){
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
        
    }
    
    func rightAnswer (){
        let ac = UIAlertController(title: "One point for Gryffindor!", message: " +1 ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Siriusly Dope", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @ objc func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let file = Bundle.main.url(forResource: "rawData", withExtension: "txt"){
            if let fileContent = try? String(contentsOf: file) {
                var lines = fileContent.components(separatedBy: "\n")
                lines.shuffle()
                
                let newLines = lines.filter { $0 != "" }
                
                for (index, line) in newLines.enumerated() {
                    
                    let parts = line.components(separatedBy: "- ")
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
        
        //        print(clueString)
        //        print(solutionString)
        
        // configure buttons and labels
        
        
        cluesLabel.text = clueString
        answersLabel.text = solutionString
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
            
        }
    }
}






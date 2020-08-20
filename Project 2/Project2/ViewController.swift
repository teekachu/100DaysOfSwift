//
//  ViewController.swift
//  Project2
//
//  Created by Ting Becker on 4/28/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//  set 3 buttons, set 3 variables, once view loads, add all items in the string to countries and run askQueston()
//  first shuffle items in string, then load first 3 items to each button. pick a random number as the correctAnswer, show it in title
//  when tap button, if button tapped is the same/not the same as correct answer, add/minus 1 to score, show warning.

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var tapped = 0
    
    var score = 0
    var highScore = 0
    var buttons = [UIButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        buttons += [button1, button2, button3]

        for button in buttons{
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.orange.cgColor
            button.layer.cornerRadius = 30
            button.imageView?.layer.cornerRadius = 30
            button.backgroundColor = .clear
        }
        
//        button1.layer.borderWidth = 1.5
//        button2.layer.borderWidth = 1.5
//        button3.layer.borderWidth = 1.5
//
//        button1.layer.borderColor = UIColor.lightGray.cgColor
//        button2.layer.borderColor = UIColor.lightGray.cgColor
//        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareWhenTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "High Score", style: .plain, target: self, action: #selector(myHighScore))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(clearAllPoints))
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "score"){
            let jsonDecoder = JSONDecoder()
            
            do{
                highScore = try jsonDecoder.decode(Int.self, from: savedScore as! Data)
            }catch{
                print("failed to load score")
            }
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        let nameToGuess = countries[correctAnswer].uppercased()
        title = "Guess the flag" + "\(nameToGuess.uppercased())"
        
    }
    
    @objc func myHighScore(_ Sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "HIGH SCORE", message: "\(highScore)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc func clearAllPoints(_ Sender: UIBarButtonItem){
        score = 0
        highScore = 0
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            sender.transform = .identity
        })
//        { _ in
//            sender.transform = .identity
//        }
        
        //        if sender.tag != correctAnswer && score == 0 {
        //            return
        //        } else if sender.tag != correctAnswer && score != 0 {
        //            score -= 1
        //        }
        //
        //        title = "No, this is the flag of \(countries[sender.tag])"
        //        tapped += 1
        //        save()
        //
        //    } else if sender.tag == correctAnswer{
        //
        //    title = "You got it!"
        //    score += 1
        //    tapped += 1
        //    save()
        //    }
        
        if sender.tag == correctAnswer {
            title = "You got it!"
            score += 1
            tapped += 1
            save()
        } else {
            title = "No, this is the flag of \(countries[sender.tag])"
            if score > 0 {
                score -= 1
            }
            tapped += 1
            save()
            
        }
        
        //        if tapped == 10 {
        //        let final = UIAlertController(title: "End Game", message: " Your final score is \(score) out of \(tapped)", preferredStyle: .alert)
        //        final.addAction(UIAlertAction(title: "continue", style: .default, handler: askQuestion))
        //        present(final, animated: true)
        //        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
        if score > highScore{
            let alert = UIAlertController(title: "New High Score", message: "Good job! You just beat the high score of \(highScore) ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cool, imma keep going", style: .cancel))
            present(alert, animated: true)
            
            highScore = score
        }
        
        
        print(score)
        print(highScore)
    }
    
    
    //    @objc func shareWhenTapped () {
    //        let vc = UIActivityViewController(activityItems: ["The score is \(score)"], applicationActivities: nil)
    //        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    //        present(vc, animated: true)
    //
    //    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedScore = try? jsonEncoder.encode(score){
            let defaults = UserDefaults.standard
            defaults.set(savedScore, forKey: "score" )
        } else {
            print("failed to save previous points")
        }
    }
    
}





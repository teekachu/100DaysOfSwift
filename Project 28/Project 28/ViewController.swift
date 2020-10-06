//
//  ViewController.swift
//  delete - pro28
//
//  Created by Tee Becker on 10/6/20.
//

import UIKit
import LocalAuthentication // need it to use faceID/ touchID

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var secret: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // use notification center to watch for and tell us when application stop being active or lose focus. It calls saveSecretMessage directly which will then hide the textView
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        
        let enter = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(enterIntoText))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [ space, enter, space]
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
    }
    
    @objc func tappedDone(){
        saveSecretMessage()
    }
    
    func showAlert(title: String, detail:String){
        let ac = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: manualPassword))
        present(ac, animated: true)
    }
    
    func manualPassword(sender: UIAlertAction){
        
        let ac = UIAlertController(title: "Please enter your password below", message: "Hint: It is your birth year", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "confirm", style: .default, handler: { (_) in
            
            if let enteredText = ac.textFields?[0].text{
                if enteredText == "1992" {
                    self.unlockSecretMessage()
                    self.label.isHidden = true
                    self.secret.isHidden = false
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.isToolbarHidden = true
                } else{
                    
                    let ac = UIAlertController(title: "Wrong Password", message: "YOU IMPOSTERRR!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "You should be sorry!", style: .default))
                    self.present(ac, animated: true)
                    
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    @objc func enterIntoText(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself, or you shall not pass"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] (success, failure) in
                
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                        
                        self?.label.isHidden = true
                        self?.secret.isHidden = false
                        self?.navigationController?.navigationBar.isHidden = false
                        self?.navigationController?.isToolbarHidden = true
                        
                    } else {
                        //error
                        
                        self?.showAlert(title: "Authentication failed", detail: "Please try again in a bit")
                        
                    }
                    
                }
            }
        } else{
            // no biometry
            showAlert(title: "Biometry Unavailable", detail: "Your device is not configured for biometric authentication")
        }
        
    }
    
    func unlockSecretMessage(){
        // basically loading the text from KeychainWrapper ( kind of like userDefaults)
        if let textToLoad = KeychainWrapper.standard.string(forKey: "secretMessage"){
            secret.text = textToLoad
        }
    }
    
    @objc func saveSecretMessage(){
        // make sure textview isn't hidden
        guard secret.isHidden == false else{return}
        // save it the same way as UserDefault by giving it a key
        KeychainWrapper.standard.set(secret.text, forKey: "secretMessage")
        // tell textView we are done with editing and get rid of keyboard
        secret.resignFirstResponder()
        // hide textview
        secret.isHidden = true
        label.isHidden = false
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = false
        
        label.text = "HEY Look away, nothing to see here"
    }
    
    //1. receive parameter that is type notification, include the name of notification as well as a Dictionary containing notification specific info called userInfo
    @objc func adjustForKeyboard(notification: Notification){
        
        //2. the dictionary will contain a key called UIresponder.keyboardFrameEndUserInfoKey - telling us the (cgRect) frame of keyboard after finished animating. Type cast into NSValue (Key value voding) because objC dictionaries can not contain CGRect.
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        //3. use cgRectValut to read that value
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        //4. use convert to factor in rotation into frame ( landscape mode will have width and height flipped)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        //5.
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
}


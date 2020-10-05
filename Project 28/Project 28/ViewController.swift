//
//  ViewController.swift
//  Project 28
//
//  Created by Tee Becker on 10/5/20.
//  Intro to faceID, keychainWrapper - read and write keychain Values


import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    @IBOutlet var authenticate: UIButton!
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        // & is called  pointer in OBJ-C - points to a place in memory where something exists rather than passing the actual value
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify Yo-self"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, failure) in
                
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                    } else{
                        // error
                        self?.alertForError(errorTitle: "Authentication failed", errorMessage: "Unable to varify, please try again")
                    }
                }
            }
        } else {
            // no biometry
            alertForError(errorTitle: "Biometry unavailable", errorMessage: "Your device is not configured for biometric authentication")
        }
        
        
    }
    
    func alertForError(errorTitle: String, errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle:.alert )
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Secret Stash"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    // TouchID and FaceID need to accomplish 3 things:
    // 1. If device is capable of supporting biometric authentication (is hardware available?)
    // 2. If so, request the hardware to begin a check, provide string of the reason we are asking. (TouchID String written in code / FaceID String in info.plist
    // 3. If we get success back from authentication request - unlock app. Else, show error msg.
    
    
    
    @objc func adjustForKeyboard(notification: Notification){
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{return}
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardDidHideNotification{
            secret.contentInset = .zero
        } else{
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
        
    }
    
    func unlockSecretMessage(){
        // show the textView and then load the keychain into it
        // make sure textview is not hidden
        secret.isHidden = false
        title = "Shhhh, it's Secret Stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "secretMessage"){
            secret.text = text
        }
    }
    
    @objc func saveSecretMessage(){
        // save the messege
        // first makesure the textView is not hidden
        guard secret.isHidden == false else{return}
        
        // set the key to be "secretMessage" and then hide the textview. change title
        KeychainWrapper.standard.set(secret.text, forKey: "secretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        
    }
    
    
    
}


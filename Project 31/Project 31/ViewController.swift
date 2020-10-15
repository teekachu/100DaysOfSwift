//
//  ViewController.swift
//  Project 31
//
//  Created by Tee Becker on 10/12/20.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    var webview: WKWebView?
    weak var activeWebview: WKWebView? // to resolve strong ref cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addressBar.delegate = self
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [add, delete]
        
        setDefaultTitle()
        
    }

    func setDefaultTitle(){
        
        title = "MultiWebBrowser"
        
    }

    
    @objc func addWebView(){
        webview = WKWebView()
        webview?.navigationDelegate = self
        
        stackView.addArrangedSubview(webview!)
        
        if let url = URL(string: "https://github.com/teekachu"){
            webview?.load(URLRequest(url: url))
        }
        
        recognizeTapGestureInWebView()
    }
    
    @objc func deleteWebView(){
    // removeFromSuperView() deletes and destroys the view, while removeArrangedSubview() only deletes but keeps view in memory so no need to recreate.
        
        if let selectedWebview = activeWebview{
            // find the index of active webview
            if let index = stackView.arrangedSubviews.firstIndex(of: selectedWebview){
                // remove the active webview based on that index
                selectedWebview.removeFromSuperview()
                
                // if there are no more subviews open, change title to default
                if stackView.arrangedSubviews.count == 0{
                    setDefaultTitle()
                    
                } else{
                    //otherwise, convert the index into an Int
                    var currentIndex = Int(index)
                    
                    // if that was the last webview in stack, go back one ( because indexes start from 0)
                    if currentIndex == stackView.arrangedSubviews.count{
                        currentIndex = stackView.arrangedSubviews.count - 1
                        
                    }
                    // find the web view at the new index and select that one
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView{
                        selectWebView(newSelectedWebView)
                    }
                    
                }
            }
        }
        
    }
    
    
    // webview utilities
   
    // let user tap on webview to activate, highlight to show in control.Change line width too as default is 0
    func recognizeTapGestureInWebView(){
        webview?.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webview!)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webviewTapped))
        recognizer.delegate = self
        webview?.addGestureRecognizer(recognizer)
        
    }
    
    func selectWebView(_ webview: WKWebView){
        // gets called when we want to ACTIVATE a webview - to show the current one in use to navigate to diff URL. Make border wider ( because later will add color to highlight)
        
        for webview in stackView.arrangedSubviews{
            webview.layer.borderWidth = 0
        }
        
        activeWebview = webview
        webview.layer.borderWidth = 3
        
    }
    
    @objc func webviewTapped(_ recognizer: UIGestureRecognizer){
        // to get the gesture recognizer to start working
        
        if let selectedWebview = recognizer.view as? WKWebView{
            selectWebView(selectedWebview)
        }
    }
    
    func gestureRecognizer (_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return true
    }
    
    // when active, show page title in nav bar; if enter new URL, load inside active webview only.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let webview = activeWebview, let address = addressBar.text{
            if address.contains("https://"){
                if let url = URL(string: address){
                    webview.load(URLRequest(url: url))
                    textField.text = ""
                }
            } else if !address.contains(".com") && !address.contains("https://"){
                if let url = URL(string: "https://"+address+".com"){
                    webview.load(URLRequest(url: url))
                    textField.text = ""
                }
            } else{
                if let url = URL(string: "https://"+address){
                    webview.load(URLRequest(url: url))
                    textField.text = ""
                }
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}


//
//  ViewController.swift
//  Project 4
//
//  Created by Ting Becker on 5/8/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//
import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites = ["google.com","apple.com","hackingwithswift.com"]
    var selectedSite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let url = URL(string: "https://" + selectedSite! + ".com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,forKeyPath: #keyPath(WKWebView.estimatedProgress),options:.new, context: nil)
        
/*        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OPEN", style: .plain, target: self, action: #selector(openTapped))
*/
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let undo = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goBack))
        let redo = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressButton, spacer, refresh, undo, redo]
        navigationController?.isToolbarHidden = false
        
        }
    
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites{
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            let denied = UIAlertController(title: "denied", message: "This site is not allowed", preferredStyle: .alert)
            denied.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            present(denied, animated: true)
            
        }
            decisionHandler(.cancel)
        }




}

    
    
    




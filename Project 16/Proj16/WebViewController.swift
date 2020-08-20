//
//  WebViewController.swift
//  Proj16
//
//  Created by Ting Becker on 7/28/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webview: WKWebView!
    var selectedCapitalCity: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCapitalCity
        
        webview = WKWebView()
        webview.navigationDelegate = self
        //        view = webview
        // Do any additional setup after loading the view.
        
        if let selectedCity = selectedCapitalCity{
            //            if let url=URL(string: "https://www.google.com"){
            //                webview.load(URLRequest(url: url))
            //                webview.allowsBackForwardNavigationGestures = true
            //            }
            
            if let url = URL(string:
                "https://en.wikipedia.org/wiki/\(selectedCity)"){
                webview.load(URLRequest(url: url))
                webview.allowsBackForwardNavigationGestures = true
            }
            
            webview.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(webview)
            
            webview.leftAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leftAnchor, multiplier: 0).isActive = true
            webview.rightAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.rightAnchor, multiplier: 0).isActive = true
            webview.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
            webview.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0).isActive = true
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

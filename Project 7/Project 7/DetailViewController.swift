//
//  DetailViewController.swift
//  Project 7
//
//  Created by Ting Becker on 6/18/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webview: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else{ return }
        let html = """
            <html>
            <head>
            <meta name = "viewport" content= "width=device-width, initial-scale=1">
            <style> body {font-size: 130%;} </style>
            </head>
            <body>
            \(detailItem.body)
            </body>
            </html>
            """
        
        webview.loadHTMLString(html, baseURL: nil)

        // Do any additional setup after loading the view.
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

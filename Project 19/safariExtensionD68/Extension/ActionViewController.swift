//
//  ActionViewController.swift
//  Extension
//
//  Created by Ting Becker on 8/10/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    var pageTitle = ""
    var pageURL = ""
//    var pageBody = ""
    
    @IBOutlet var script: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //use extensionContect to control how we interact with parent app
        //find first item in inputitems
        //find first attachment in that first input item
        //load attachment, use type identifier kUTTypePropertyList
        //typecast dict as NSDictionary
        //typecast that same dict as NSDictionary using key NSExtensionJavaScriptPreprocessingResultsKey
        //set pageTitle and pageURL, push title on to main thread using GCD
        
        if let firstInputItem = extensionContext?.inputItems.first as? NSExtensionItem{
            if let firstAttachment = firstInputItem.attachments?.first{
                firstAttachment.loadItem(forTypeIdentifier: kUTTypePropertyList as String){
                    [weak self] (dict, error) in
                    
                    guard let itemDictionary = dict as? NSDictionary else{return}
                    guard let javascriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else{return}
                    
                    //                    print(javascriptValues)
                    
                    self?.pageTitle = javascriptValues["title"] as? String ?? "unable to extract Title"
                    self?.pageURL = javascriptValues["URL"] as? String ?? "unable to extract URL"
//                    self?.pageBody = javascriptValues["body"] as? String ?? " Unable to extract body text"
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        let notificationCenter = NotificationCenter.default
        //takes 4 parameters:
            // who should receive notification (self)
            // what method will be called (adjustKeyboard)
            // what notification we want to receive (both keyboardWillHideNotification && keyboardWillChangeFrameNotification)
            // who we want to send the notification
        
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func adjustKeyboard(notification: Notification){
        // receive parameter that is type Notification, which includes the name & the Dictionary that contains the notification containing UserInfo
        // the dictionary will contain a key called "UIResponder.keyboardFrameEndUserInfoKey" ( it is type cgRect )
        // objc doesn't read cgRect, so we typecast as NSValue
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        // we use cgRectValue because we know it contains cgRect
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        // after pulling the frame, convert the rectangle to the view's co-coordinates (factor in rotation)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        //adjust contentInset of the textview
        if notification.name == UIResponder.keyboardWillHideNotification{
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            //adjust our keyboard calculation by the safe area's bottom value.
        }
        //adjust scrollIndicatorInsets of the textview
        script.scrollIndicatorInsets = script.contentInset
        //make the textview scroll so the text entry cursor is visible.
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        
        //        1. Create a new NSExtensionItem object that will host our items.
        let item = NSExtensionItem()
        //        2. Create a dictionary containing the key "customJavaScript" and the value of our script.
        let argument: NSDictionary = ["customJavaScript": script.text ?? "unable to pull text"]
        //        3. Put that dictionary into another dictionary with the key NSExtensionJavaScriptFinalizeArgumentKey.
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        //        4. Wrap the big dictionary inside an NSItemProvider object with the type identifier kUTTypePropertyList.
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        //        5. Place that NSItemProvider into our NSExtensionItem as its attachments.
        item.attachments = [customJavaScript]
        //        6. Call completeRequest(returningItems:), returning our NSExtensionItem.
        
        extensionContext?.completeRequest(returningItems: [item])
                
    }
    
}

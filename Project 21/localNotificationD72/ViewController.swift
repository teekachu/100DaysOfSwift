//
//  ViewController.swift
//  localNotificationD72
//
//  Created by Ting Becker on 8/19/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var items = [UIBarButtonItem]()
    
    
    @objc func registerLocal(){
        // set the notification center to current
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted{
                print("access granted by user")
            } else {
                print("Let me innnnnn humannn")
            }
        }
        
    }
    
    func addingAction(){
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self // any alert based will be returned to our view contr.
        
        let showMore = UNNotificationAction(identifier: "IDforActionToShowMore", title: "Show Me Detail", options: .foreground)
        
        // adding second action to category to remind later
        let remindLater = UNNotificationAction(identifier: "IDforRemindMeLater", title: "Remind Me In 5 sec", options: .authenticationRequired)
        
        let category = UNNotificationCategory(identifier: "uniqueID", actions: [showMore, remindLater], intentIdentifiers: [] )
        
        center.setNotificationCategories([category])
        
    }
    
    
    @objc func scheduleLocal() {
        // after receiving access
        
        addingAction()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        //WHEN
        
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
//        //everyday at 2pm / 14:00
//        var dateComponents = DateComponents()
//        dateComponents.hour = 14
//        dateComponents.minute = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //WHAT
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default
        
        content.userInfo = ["contentUserInfoKey": "contentUserInfoValue"] // will get handed back
        content.categoryIdentifier = "uniqueID" // same as the catagory uniqueID, use this to register to button ("show me detail")
        
        center.add(UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger), withCompletionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Intro to User Notifications"
        // Do any additional setup after loading the view.
        
        self.navigationController?.isToolbarHidden = false
        
        items.append(
            UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        )
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        items.append(
            UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        )
        
        toolbarItems = items
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["contentUserInfoKey"] as? String{
            print("custom data received for : \(customData)")
            
            switch response.actionIdentifier{
                
            case UNNotificationDefaultActionIdentifier:
                print("the user swiped to unlock")
                
            case "IDforActionToShowMore":
                print("user tapped show more button")
                
            case "IDforRemindMeLater":
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.scheduleLocal()
                }
                
                
                print("user tapped remind me later")
                
            default:
                break
            }
            
        }
        
        completionHandler()
        
    }
}


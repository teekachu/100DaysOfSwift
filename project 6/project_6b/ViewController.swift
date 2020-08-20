//
//  ViewController.swift
//  project_6b
//
//  Created by Ting Becker on 6/13/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false //by default IOS generates autolayout constrants based on view size and position, we will do this manually here
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()  // labels will be sized to fit the content
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()
        
        //to add the labels into the view currently in view controller
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
    //below are using VFL
//        // add dictionary of all labels
//        let viewsDictionary = [
//            "Label1": label1,
//            "Label2": label2,
//            "Label3": label3,
//            "Label4": label4,
//            "Label5": label5
//        ]
//
//        //VFL - (auto layout) visual format langugae
//        for label in viewsDictionary.keys {
//            //horizontal constrants
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//            //vertical constrants
//        }
//
//        let metrics = ["LabelHeight": 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[Label1(LabelHeight@999)]-[Label2(Label1)]-[Label3(Label1)]-[Label4(Label1)]-[Label5(Label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))


      //below are using ANCHORS
        
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
            
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            //used leading and trailing anchor instead of width
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
            
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previous = label
        }
        
    }


}


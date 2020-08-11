//
//  DetailViewController.swift
//  Cons_Project#1
//
//  Created by Ting Becker on 5/6/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var buttonTapped: UIImageView!
    var selectedImage: String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

//this is what loads the actual photo
    if let imageToLoad = selectedImage {
            buttonTapped.image = UIImage(named: imageToLoad)
        }

// if the name of (variable name) is the same as whats in the selected image ( created to hold name of image that should load) , then the actual image view in story board called ( buttonTapped) should be name of (variable name)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SHARE", style: .plain, target: self, action: #selector(shareTapped))
     
    }
    
    @objc func shareTapped() {
        guard let image = buttonTapped.image?.jpegData(compressionQuality: 0.8) else {
            print("no images found")
            return
        }
        
        let shareName = "\(selectedImage!.uppercased())"
        
        
        let vc = UIActivityViewController(activityItems: [shareName, image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    
        

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

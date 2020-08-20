//
//  DetailViewController.swift
//  Project1
//
//  Created by Ting Becker on 4/25/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalPictures = 0 //new
    var selectedPictureNumber = 0//new
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let one = "picture \(selectedPictureNumber) of \(totalPictures)"
        title = one
        
//        assigning rightBarButtonItem of our view controller's navigationItem , on the right we have a new item called UIBarButtonItem that have 3 parameters: target: self means the method belongs to the current view controller - self, and action parameter is saying, when you are tapped, call the shareTapped() method.
 
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action
            , target: self, action: #selector(shareTapped))
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //create shareTapped method
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("no image found")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
    
   /* @objc func shareTapped () {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print(" No image found ")
            return
        }
    let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

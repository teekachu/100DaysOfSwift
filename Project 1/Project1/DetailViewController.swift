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

        // i changed this
        let one = "picture \(selectedPictureNumber) of \(totalPictures)"
        title = one
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        assert(selectedImage != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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

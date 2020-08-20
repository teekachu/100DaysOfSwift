//
//  DetailViewController.swift
//  Cons_Project # 10-12
//
//  Created by Ting Becker on 7/10/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var detailImage: UIImageView!

    var selectedImage: String?
    var photoTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = photoTitle
        
        if let imageToload = selectedImage{
            detailImage.image = UIImage(named: imageToload)
        }
        
    }
}

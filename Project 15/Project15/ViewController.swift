//
//  ViewController.swift
//  Project15
//
//  Created by Ting Becker on 7/22/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

//extension UIView{
//    func bounceOut(_ duration: Double){
//
//        UIView.animate(withDuration: duration) {[weak self] in
//
//            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
//        }
//    }
//}

class ViewController: UIViewController {

    
    var imageView: UIImageView!
    
    var currentAnimation = 0
    
    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        //        UIView.animate(withDuration: 1, delay: 0, options: []
        UIView.animate(withDuration: 1, delay: 0 , usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [] // the newly added two parameter and made the transition faster
            , animations: {
                switch self.currentAnimation{
                case 0:
                    self.imageView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                    
                case 1:
                    self.imageView.transform = .identity
                    
                case 2:
                    self.imageView.transform = CGAffineTransform(translationX: -100, y: -100)
//                    self.imageView.transform = CGAffineTransform(translationX: -100, y: 100)
//                    self.imageView.transform = CGAffineTransform(translationX: 100, y: -100)
//                    self.imageView.transform = CGAffineTransform(translationX: 100, y: 100)
                // differences between current x/y position. we are basically subtracting 200 from each position
                case 3:
                    self.imageView.transform = .identity
                    
                case 4:
                    self.imageView.transform = CGAffineTransform(rotationAngle: 120)
                // with rotationAngle, we need to use a radian ( cgfloat.pi or a number), core animation will take smallest route, i.e 270 degrees rotate will be counterclock wise 60 degrees, because its smaller, and 360 degrees will not even move because we are already here.
                    
                case 5:
                    self.imageView.transform = .identity
                    
                case 6:
                     self.imageView.transform = CGAffineTransform(translationX: 50, y: 50)
                    
                case 7:
                    self.imageView.transform = .identity
                    
                default:
                    break
                }
                
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7{  // setting the limit of animation rounds.
            currentAnimation = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pikachuPic = UIImage(named: "penguin") else{return}
        imageView = UIImageView(image: pikachuPic)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        //        imageView.center = view.center
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(action))
        
    }
    
//    @objc func action(){
//        self.view.bounceOut(3)
//    }
//
    
}


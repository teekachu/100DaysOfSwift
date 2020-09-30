//
//  ViewController.swift
//  Cons_Project#9
//
//  Created by Tee Becker on 9/29/20.

//1. Prompt the user to import a photo from their photo library.
//2. Show an alert with a text field asking them to insert a line of text for the top of the meme.
//3. Show a second alert for the bottom of the meme.
//4. Render their image plus both pieces of text into one finished UIImage using Core Graphics.
//5. Let them share that result using UIActivityViewController.


import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageview: UIImageView!
    
    //placeholder for photo
    var imageName: UIImage?
    //placeholder for first paragraph
    var topParagraph: String = "TOP PLACEHOLDER"
    //placeholder for bottom paragraph
    var bottomParagraph: String = "BOTTOM PLACEHOLDER"
    
    //    override func loadView() {
    //        initialAlert()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        initialAlert()
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Top text", style: .plain, target: self, action: #selector(addTopCaptions))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bottom text", style: .plain, target: self, action: #selector(addBottomCaptions))
        
        let bottomBarItem = UIBarButtonItem(title: "Share Meme", style: .plain, target: self, action: #selector(shareWithFriend))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [flexibleSpace,bottomBarItem,flexibleSpace]
        navigationController?.setToolbarHidden(false, animated: true)
        
        //        addRenderer()
    }
    
    func initialAlert(){
        let ac = UIAlertController(title: "Upload a photo for your meme", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: imagePicker))
        present(ac, animated: true)
    }
    
    @objc func imagePicker(_ sender: UIAlertAction){
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageName = image
        }
        // do i need this?
        dismiss(animated: true)
        addRenderer()
    }
    
    @objc func addTopCaptions(){
        // add words
        let ac = UIAlertController(title: "Top sentence", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "done", style: .default, handler: {[weak self, weak ac] _ in
            
            if let topText = ac?.textFields?[0].text{
                self?.topParagraph = topText
            }
            
            self?.addRenderer()
        }))
        
        present(ac, animated: true)
    }
    
    
    @objc func addBottomCaptions(){
        // add words
        let ac = UIAlertController(title: "Bottom sentence", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "done", style: .default, handler: {[weak self, weak ac] _ in
            
            if let bottomText = ac?.textFields?[0].text{
                self?.bottomParagraph = bottomText
            }
            
            self?.addRenderer()
        }))
        
        present(ac, animated: true) {
            //do stuff
        }
    }
    
    @objc func shareWithFriend(){
        // activitycontroller
        let action = UIActivityViewController(activityItems: [imageview.image], applicationActivities: nil)
        present(action, animated: true)
        
    }
    
    //    1. Create a renderer at the correct size.
    //    2. closure: Define a mutableParagraph style that aligns text to the center.
    //    3. Create an attributes dictionary containing that paragraph style, and also a font.
    //    4. Wrap that attributes dictionary and a string into an instance of NSAttributedString.
    //    5. Load an image from the project and draw it to the context.
    //    6. Update the image view with the finished result.
    
    func addRenderer(){
        
        let width = imageview.bounds.width
        let height = imageview.bounds.width + 20
        
        //render the photo
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { (context) in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let bottomParagraphStyle = NSMutableParagraphStyle()
            bottomParagraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .paragraphStyle: paragraphStyle
            ]
            
            let topAttributeString = NSAttributedString(string: topParagraph, attributes: attrs)
            topAttributeString.draw(with: CGRect(x: 0, y: 5, width: width, height: 40), options: .usesLineFragmentOrigin, context: nil)
            
            let bottomAttributeString = NSAttributedString(string: bottomParagraph, attributes: attrs)
            bottomAttributeString.draw(with: CGRect(x: 0, y: height - 45, width: width, height: 40), options: .usesLineFragmentOrigin, context: nil)
            
            if let imageToLoad = imageName{
                
                imageToLoad.draw(in: CGRect(x: 0, y: 40, width: width, height: height - 90)
                                 
                )}
            
            
        }
        
        imageview.image = img
    }
    
    
}

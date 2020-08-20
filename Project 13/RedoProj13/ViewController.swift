//
//  ViewController.swift
//  RedoProj13
//
//  Created by Ting Becker on 7/16/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
//1. to use coreImage
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentImage: UIImage!
    //2. to add 2 more properties
    var context: CIContext! // rendering
    var currentFilter: CIFilter! //holds the filter activated
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var Slider: UISlider!
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    //NEW
    @IBOutlet var buttonChangeFilter: UIButton!
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Change Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else{
            //error Message
            return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        //the name of the selector is basically the parameter names of func image
        //_ means empty and : is to seperate
    }
    //takes in 3 parameters, image to write, what method to call, and context
    @objc func image(_ image: UIImage, didFinishSavingWithError: Error?, contextInfo: UnsafeRawPointer){
        if let error = didFinishSavingWithError {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else{
            let ac = UIAlertController(title: "Saved", message: "Saved photo in library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My Filter App"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoFromAlbum))
        
        context = CIContext() //default CoreImage context
        currentFilter = CIFilter(name: "CISepiaTone") //default filter
        alertIntro()
    }
    
    @objc func takePhoto(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    @objc func addPhotoFromAlbum(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        //set currentImage to be the editedImage in imagePicker
        currentImage = image
        
        //to apply value in slider to the filter's value that apply to the image
        //since currentImage is UIimage, we need to turn it to CIImage to use CoreImage
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 0
        }) { _ in
            
            self.applyProcessing()
            self.imageView.alpha = 1
        }
        
        //run the method to process the data, kind of like tableview.reload
        //as soon as image is finished imported
        //        applyProcessing()
        
    }
    
    func applyProcessing(){
        //when intensity is changed, and when finished loading the image and wants to apply default filter "Sepia" to image
        //1. reads the output image of the currentFilter, set intensity slider value to the coreImageFilter value, using intensityKey, create new CIImage data type , render all the image, set the CIimage back as UIimage and put it inside Imageview.image
        
        //        guard let image = currentFilter.outputImage else{return}
        //        //This line sets the intensity of currentFilter
        //        currentFilter.setValue(Slider.value, forKey: kCIInputIntensityKey)
        
        //every filter has an input Key
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(Slider.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(Slider.value * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(Slider.value * 10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey){
            currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)}
        
        if let cgimage = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgimage)
            self.imageView.image = processedImage
        }
        
    }
    
    func setFilter(action : UIAlertAction) {
        guard currentImage != nil else{return}
        
        guard let filterTitle = action.title else{return}
        currentFilter = CIFilter(name: filterTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
        //NEW
        buttonChangeFilter.setTitle(filterTitle, for: .normal)
    }
    
    func alertIntro(){
        let ac = UIAlertController(title: "HELLO", message: "Please first add a photo using the camera or add button on top ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
}


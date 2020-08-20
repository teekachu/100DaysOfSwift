//
//  ViewController.swift
//  Cons_Project # 10-12
//
//  Created by Ting Becker on 7/7/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [eachCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = " My Disposable Camera"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadPhoto))
        //        let defaults = UserDefaults.standard
        //
        //        if let savedPeople = defaults.object(forKey: "savedData") as? Data{
        //            let jsonDecoder = JSONDecoder()
        //
        //            do{
        //                pictures = try jsonDecoder.decode([eachCell].self, from: savedPeople)
        //            } catch {
        //                print("Failed to load people")
        //            }
        //        }
    }
    
    @objc func uploadPhoto(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    /*Extract the image from the dictionary that is passed as a parameter.
     Generate a unique filename for it.
     Convert it to a JPEG, then write that JPEG to disk.
     Dismiss the view controller.*/
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let newCell = eachCell(caption: "What is this photo about?", photo: imageName)
        pictures.append(newCell)
        dismiss(animated: true){
            
            let ac = UIAlertController(title: "Adding captions to photo", message:  nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Add", style: .default) {[weak self, weak ac] _ in
                if let newLabel = ac?.textFields?[0].text{
                    newCell.caption = newLabel
                    self?.tableView.reloadData()
                    self?.save()
                }
            })
            self.present(ac, animated: true)
        }
        tableView.reloadData()
        save()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rows = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CaptionedPhoto else{
            fatalError("something went wrong with deque")
        }
        let person = pictures[indexPath.row]
        rows.caption.text = person.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(person.photo)
        rows.imageView?.image = UIImage(contentsOfFile: path.path)
        
        rows.imageView?.clipsToBounds = true
        rows.imageView?.layer.cornerRadius = 10
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController{
            
            let path = getDocumentsDirectory().appendingPathComponent(pictures[indexPath.row].photo)
            vc.selectedImage = path.path
            vc.photoTitle = pictures[indexPath.row].caption
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures){
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "savedData")
        } else {
            print("unable to save data")
        }
        
    }
    
    
    
}

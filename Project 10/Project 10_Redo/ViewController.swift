//
//  ViewController.swift
//  Project 10_Redo
//
//  Created by Ting Becker on 6/29/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    var people = [Person]()
    var empty = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        empty = []
        
        // Do any additional setup after loading the view.
        // FIRST hide the nav bar to add new pictures
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(exitAppAndSave))
        navigationController?.navigationBar.isHidden = true
        
        // Show the tool bar for authentication
        let authenticate = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticateTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [space, authenticate, space]
        navigationController?.isToolbarHidden = false
        
        //        //loading data to pull saved out of defaults and load
        //
        //        let defaults = UserDefaults.standard
        //
        //        if let savedPeople = defaults.object(forKey: "people"){
        //            let jsonDecoder = JSONDecoder()
        //
        //            do{
        //                people = try jsonDecoder.decode([Person].self, from: savedPeople as! Data)
        //            } catch {
        //                print("unable to load")
        //            }
        //        }
    }
    
    func loadData(){
        //loading data to pull saved out of defaults and load
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people"){
            let jsonDecoder = JSONDecoder()
            
            do{
                people = try jsonDecoder.decode([Person].self, from: savedPeople as! Data)
                collectionView.reloadData()
                
            } catch {
                print("unable to load")
            }
        }
    }
    
    @objc func exitAppAndSave(){
        //
        people = empty
        collectionView.reloadData()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = false
    }
    
    @objc func authenticateTapped(){
        // if pass, show photos and names. tableview.refresh
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            let reason = "Show us your identity or YOU SHALL NOT PASS"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] (success, failure) in
                
                DispatchQueue.main.async {
                    if success{
                        
                        self?.loadData()
                        
                        // unlock the photos
                        
                        self?.collectionView.reloadData()
                        
                        //show /hide necessary toolbar
                        self?.navigationController?.navigationBar.isHidden = false
                        self?.navigationController?.isToolbarHidden = true
                        
                    } else {
                        // error message
                        self?.alertMessage(title: "Can not verify your identity", detail: "Please use password manually")
                    }
                }
            }
        } else{
            
            // no biometry,  show error
            self.alertMessage(title: "Biometry unavailable ", detail: "Please use password to login manually")
        }
    }
    
    func alertMessage(title: String, detail: String){
        let ac = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: usePassword))
        present(ac, animated: true)
    }
    
    func usePassword(sender: UIAlertAction){
        let ac = UIAlertController(title: "Please enter your Password", message: "Your birth year", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {[weak self] (_) in
            
            if let textExtracted = ac.textFields?[0].text{
                if textExtracted == "1992"{
                    
                    self?.loadData()
                    self?.collectionView.reloadData()
                    self?.navigationController?.navigationBar.isHidden = false
                    self?.navigationController?.isToolbarHidden = true
                    
                } else {
                    
                    let ac = UIAlertController(title: "WRONG PASSWORD", message: "Are you an imposter? ", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Hmm...", style: .cancel))
                    self?.present(ac, animated: true)
                    
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        //below are added after Person class is created
        let person = Person(name: "New Friend", image: imageName )
        people.insert(person, at: 0)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
        //first get the edited image from the dictionary and typecast as UIImage, then we create a unique filename , so we can copy to app's space without overwriting anything. We get the file path by taking the URL result of <getDocumentsDirectory> below, and calls a method to add the fileName to that path. last we convert to JPEG and write the JPEG to disk. 
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        //first asks for the documentDirectory inside fm.default.url, and we want the path to be the user's home directory. return the first item in the array(because [URL] is an array.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3 // image's cornerRadius
        cell.layer.cornerRadius = 7 // cell's cornerRadius
        
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Enter Name below", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Save Name", style: .default) { [weak ac, weak self] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Remove Friend", style: .default){ [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.save()
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else{
            print("Failed to save People :( ")
        }
    }
}


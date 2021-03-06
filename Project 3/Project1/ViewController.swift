//
//  ViewController.swift
//  Project3
//
//  Created by Ting Becker on 4/24/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//  THIS IS PROJECT 3

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareThisApp))
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl")
                {
                    self.pictures.append(item)
                    self.pictures.sort(by: <)
                }
                
            }
        }
//         print(pictures)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.totalPictures = pictures.count //new
            vc.selectedPictureNumber = indexPath.row + 1 //new
            navigationController?.pushViewController(vc, animated: true)
            
    }
    }
    
    //create shareThisApp method
//    @objc func shareThisApp() {
//        
//        let activityVC = UIActivityViewController(activityItems: [pictures], applicationActivities: [])
//        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        present(activityVC, animated: true)
//    }
    
    
}


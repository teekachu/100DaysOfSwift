//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
    
    var items = [String]() // this is the array that will store the filenames to load
//    var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
    var dirty = false
    var original: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reactionist"
        
        tableView.rowHeight = 90 // photos are WAY TOO BIG for the space.
        tableView.separatorStyle = .none
        
        //MARK-Rewrite #2
        // because there is no storyboard, this is how we register an identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        DispatchQueue.global(qos: .userInitiated).async {
            // load all the JPEGs into our array
            let fm = FileManager.default
            guard let path = Bundle.main.resourcePath else{return}

            if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
                for item in tempItems {
                    if item.range(of: "Large") != nil {
                        self.items.append(item)
                    }
                }
            }
        }
        
        // generate all images when app first Launch, and use smaller versions instead.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dirty {
            // we've been marked as needing a counter reload, so reload the whole table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") // ORIGINAL: where is dequeReusableCell???
        
//        //MARK-Rewrite #1 : To deque reusable cells first. Only if it fails to rewrite, then create new
//        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        if cell == nil{
//            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        }
        
        //MARK-Rewrite #2
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // find the image for this cell, and load its thumbnail
        let currentImage = items[indexPath.row % items.count]
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        if let path = Bundle.main.path(forResource: imageRootName, ofType: nil){
            original = UIImage(contentsOfFile: path)
        }
        
        
        //MARK: solution 2
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        //        let renderer = UIGraphicsImageRenderer(size: original.size)
        
        
        let rounded = renderer.image { ctx in
            //MARK: solution 2, make images smaller as 2500x2500 pixel is too large for height 90 cells.
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            original?.draw(in: renderRect)
            
            //            //MARK: solution 1, use setShadow() inside UIGraphicsImageRenderer so we only use 1 renderer
            //            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 200, color:  UIColor.black.cgColor)
            //            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size))
            //            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0, color: nil)
            //            // End of MARK
            
            //            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            //            ctx.cgContext.clip() //clip() only draw things lies within the path, so only the image that lies inside the circle is shown. thus making it round as original image are square
            //
            //            original.draw(at: CGPoint.zero)
        }
        
        cell.imageView?.image = rounded
        
        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath // give exact shadow by using UIBezierPath
        
        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ImageViewController()
        vc.image = items[indexPath.row % items.count]
        vc.owner = self
        
        // mark us as not needing a counter reload when we return
        dirty = false
        
        // add to our view controller cache and show
//        viewControllers.append(vc)
        navigationController!.pushViewController(vc, animated: true)
    }
}

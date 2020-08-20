//
//  DetailViewController.swift
//  Day59C
//
//  Created by Ting Becker on 7/25/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var selectedCountry: country?
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pictures += ["Bruges", "Granada","Prague","Taipei"]

        if let selected = selectedCountry?.favoriteCity {
            imageView.image = UIImage(named: selected)
        } else{
            print("error importing photo")
        }

//        imageView.image = UIImage(named: "\(selectedCountry?.favoriteCity)")
   
        guard let path = Bundle.main.path(forResource: "file", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        if let contents = try? String(contentsOf: url){ //string
            
            let jsonData = contents.data(using: .utf16)!
            
            do{
                selectedCountry = try JSONDecoder().decode(country.self, from: jsonData)}
            catch{
                print(error.localizedDescription)
            }
        }
        
        title = selectedCountry!.name
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //TODO: update later
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = selectedCountry?.favoriteCity
        cell.detailTextLabel?.text = selectedCountry?.favoriteMemory

        return cell
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

//
//  ViewController.swift
//  Day59C
//
//  Created by Ting Becker on 7/25/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countriesVisited = [country]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tee's Destinations"
        
        guard let path = Bundle.main.path(forResource: "file", ofType: "json") else {
            print("error")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        //        print(url)
        
        if let contents = try? String(contentsOf: url){ //string
            //            print(contents)
            let jsonData = contents.data(using: .utf16)!
            //            let array:[country] = try! JSONDecoder().decode([country].self, from: jsonData)
            let array: countries = try! JSONDecoder().decode(countries.self, from: jsonData)
            //            print(array.results)
            countriesVisited += array.results
            //            print(countriesVisited)
        }
    }
    
    //    func parse(json: Data) {
    //        let decoder = JSONDecoder()
    //
    //        if let jsonCountries = try? decoder.decode(countries.self
    //            , from: json){
    //            countriesVisited = jsonCountries.results
    //            tableView.reloadData()
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesVisited.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let countryName = countriesVisited[indexPath.row]
        cell.textLabel?.text = countryName.name
        cell.detailTextLabel?.text = String(countryName.timeOfVisit)
        return cell
    }
    
    //Basiclaly each selected country needs to be an array of string ( each country )
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "detailViews") as? DetailViewController else{return}
        vc.selectedCountry = countriesVisited[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}




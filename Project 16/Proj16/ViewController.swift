//
//  ViewController.swift
//  Proj16
//
//  Created by Ting Becker on 7/26/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change View", style: .plain, target: self, action: #selector(changeView))
        
        // Do any additional setup after loading the view.
        
        let taipei = Capital(title: "Taipei", info: "Walking around XiMenDing made me feel tiny, and where I met marshmellow on the street", coordinate: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654))
        let Madrid = Capital(title: "Madrid", info: "Great trip with mom, and the Plaza de España is a dream come true", coordinate: CLLocationCoordinate2D(latitude: 40.4168, longitude: 3.7038))
        let Prague = Capital(title: "Prague", info: " is a city that jumped out of a fairytail, walking on Charles bridge during sunset is one of the happiest and most beautiful memory of my life ", coordinate: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378))
        let Amsterdam = Capital(title: "Amsterdam", info: "Getting lost walking around Amsterdam was most definetely enjoyable", coordinate: CLLocationCoordinate2D(latitude: 52.3667, longitude: 4.8945))
        let SanJuan = Capital(title: "San_Juan,_Puerto_Rico", info: "My first real trip with friends, and that was a true blast", coordinate: CLLocationCoordinate2D(latitude: 18.4655, longitude: -66.1057))
        let sanFrancisco = Capital(title: "San_Francisco", info: "Land of the gold, my passion for the city's beauty and my hate for the expensive standard of living are equally strong. ", coordinate: CLLocationCoordinate2D(latitude: 37.7180273, longitude: -122.390662))
        
        mapView.addAnnotations([taipei, Madrid, Prague, Amsterdam, SanJuan, sanFrancisco])
        
    }
    
    @objc func changeView(){
        let ac = UIAlertController(title: "View in", message: "Select how you would like to view the map", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { _ in
            self.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { _ in
            self.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { _ in
            self.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "Woah!", style: .default, handler: { _ in
            self.mapView.mapType = .hybridFlyover
        }))
        ac.addAction(UIAlertAction(title: "nevermind", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // annotation is the parameter name
        guard annotation is Capital else { return nil }
        
        let reusableIdentifier = "reuseCapital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableIdentifier) as? MKPinAnnotationView
        
        // if can not find reusable view, create one using MKPinAnnotationView and set canShowCallout to true to trigger popout box with name.
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableIdentifier)
            annotationView?.canShowCallout = true
            
            // create button
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else { // if its not nil then no need to create new reusable view
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .systemTeal // it changes the color of the pin ball
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return} // pulling out the annotation property and typecast as capital( contains the title and infos)
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Go to Wiki Page", style: .default, handler: { (_) in
            //TO DO: ADD WIKI PAGE
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "wikiPage") as? WebViewController
            {
                vc.selectedCapitalCity = placeName
                self.navigationController?.pushViewController(vc, animated: true)
            }

            
        }))
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    
}

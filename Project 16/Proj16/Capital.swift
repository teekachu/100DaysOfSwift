//
//  Capital.swift
//  Proj16
//
//  Created by Ting Becker on 7/26/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {

    var title: String? // title and subtitles are optional
    var info: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, info:String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
}

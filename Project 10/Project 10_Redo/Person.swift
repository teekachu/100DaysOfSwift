//
//  Person.swift
//  Project 10_Redo
//
//  Created by Ting Becker on 7/1/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class Person: NSObject, Codable { //Codable means to read and write
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

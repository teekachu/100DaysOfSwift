//
//  eachCell.swift
//  Cons_Project # 10-12
//
//  Created by Ting Becker on 7/7/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class eachCell: NSObject, Codable {
    
    var caption: String
    var photo: String
    
    init(caption: String, photo: String) {
        self.caption = caption
        self.photo = photo
    }
}

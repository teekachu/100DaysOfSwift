//
//  Countries.swift
//  Day59C
//
//  Created by Ting Becker on 7/25/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import Foundation

struct countries:Codable {
    var results: [country]
}

struct country:Codable {
    let name: String
    let timeOfVisit: Int
    let rating: Int
    let favoriteCity: String
    let favoriteMemory: String
}



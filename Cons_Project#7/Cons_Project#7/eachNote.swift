//
//  notes.swift
//  Cons_Project#7
//
//  Created by Tee Becker on 10/5/20.
//

import Foundation

class eachNote: NSObject, Codable{
    var title: String
    var detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
    
}

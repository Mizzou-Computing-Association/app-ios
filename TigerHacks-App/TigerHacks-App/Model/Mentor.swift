//
//  Mentor.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation

struct Mentor : Decodable {
    var name: String
    var skills: [String]?
    var contact: String?
    
    enum CodingKeys : String, CodingKey
    {
        case name = "Name"
        case skills = "Skills"
        case contact = "Contacts"
    }
}

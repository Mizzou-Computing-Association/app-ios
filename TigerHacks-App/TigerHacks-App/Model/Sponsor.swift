//
//  Sponsor.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
import UIKit

struct Sponsor : Decodable {

    var mentors: [Mentor]?
    var name: String
    var description: String?
    var website: String?
    var location: String?
    var image: String?

    enum CodingKeys: String, CodingKey
    {
        case mentors = "Mentors"
        case name = "Name"
        case description = "Description"
        case website = "Website"
        case location = "Location"
        case image = "Image"
    }
    
}

//
//  Sponsor.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable type_name

struct Sponsor: Decodable {

    var mentors: [Mentor]?
    var name: String
    var description: String?
    var website: String?
    var location: String?
    var image: UIImage?
    var imageUrl: String?
    var level: String?
    
    enum CodingKeys: String, CodingKey {
        case mentors
        case name
        case description
        case website
        case location
        case imageUrl = "image"
        case level
    }
}

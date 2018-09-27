//
//  Mentor.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//


import Foundation
// swiftlint:disable type_name
struct Mentor {
    var name: String
    var skills: [String]?
    var contact: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case skills
        case contact
    }

}

extension Mentor: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        contact = try values.decode(String.self, forKey: .contact)
        let skillsString = try values.decode(String.self, forKey: .skills)
        
//        skills = skillsString.split(separator: ",")
        skills = skillsString.components(separatedBy: ",")
    }

}

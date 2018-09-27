//
//  SponsorResponse.swift
//  TigerHacks-App
//
//  Created by Evan Teters on 9/23/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
// swiftlint:disable type_name

struct SponsorResponse: Decodable {
    var sponsors: [Sponsor]
}

//
//  Profile.swift
//  TigerHacks-App
//
//  Created by Jacob Sokora on 10/16/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit

struct Profile: Codable {
	var registered: Bool
	var pass: String
	var admin: Bool
}

//
//  Model.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation

class Model {
    
    init() {
        self.sponsors = nil
        self.schedule = nil
        self.prizes = nil
    }
    var sponsors:[Sponsor]?
    var schedule:[Event]?
    var prizes:[Prize]?
}

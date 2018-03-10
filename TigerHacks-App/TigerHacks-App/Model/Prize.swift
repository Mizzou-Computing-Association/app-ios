//
//  Prize.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation

struct Prize {
    var sponsor:Sponsor?
    var title:String
    var description:String
    var prizeType:PrizeType
    
}

enum PrizeType {
    case main
    case beginner
}

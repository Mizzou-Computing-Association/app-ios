//
//  Prize.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct Prize {
    var sponsor: Sponsor?
    var title: String
    var reward: String
    var description: String
    var prizeType: PrizeType

}

enum PrizeType {
    case Main
    case Beginner
}

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
    var sponsorID: String?
    var title: String
    var reward: String
    var description: String
    var prizeType: PrizeType
    var order: Int

}

enum PrizeType: String {
    case Main
    case Developer
    case Beginner
    case StartUp
    case Visual
    case Sponsored
    case Visuals
    case Audio
    case Hardware
}

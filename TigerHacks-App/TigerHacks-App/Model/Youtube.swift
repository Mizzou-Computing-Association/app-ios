//
//  YoutubeSnippet.swift
//  FoodComboAPIDemo
//
//  Created by Jonah Zukosky on 4/18/18.
//  Copyright © 2018 Tech Innovator. All rights reserved.
//

import Foundation

struct YoutubeSnippet {
    var title: String = ""
    var description: String = ""
    var resourceId: YoutubeResourceID = YoutubeResourceID()
}

struct YoutubeResourceID {
    var videoId: String = ""
}

//
//  Event.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
import UserNotifications

struct Event {
    var time: Date
    var day: Int
    var location: String
    var floor: Int
    var title: String
    var description: String

    var content: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()

        content.title = NSString.localizedUserNotificationString(forKey: self.title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: self.description, arguments: nil)
        content.sound = UNNotificationSound.default

        return content
    }

    var trigger: UNCalendarNotificationTrigger {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.time.addingTimeInterval(-15*60))
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }

    var request: UNNotificationRequest {
        return UNNotificationRequest(identifier: self.title, content: self.content, trigger: self.trigger)
    }
}

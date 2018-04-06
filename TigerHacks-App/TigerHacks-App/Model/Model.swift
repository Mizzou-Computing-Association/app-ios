//
//  Model.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation

class Model {
    
    static var sharedInstance = Model()
    
    init() {
        
    }
    var sponsors:[Sponsor]?
    var dayOneSchedule:[Event]?
    var dayTwoSchedule:[Event]?
    var dayThreeSchedule:[Event]?
    var prizes:[Prize]?
    var resources:[Resource]?
    
    func fakeAPICall(){
        
        let myCalendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.day = 12
        dateComponents.hour = 20
        dateComponents.minute = 30
        var dateComponents1 = DateComponents()
        dateComponents1.day = 13
        dateComponents1.hour = 12
        dateComponents1.minute = 00
        var dateComponents2 = DateComponents()
        dateComponents2.day = 14
        dateComponents2.hour = 8
        dateComponents2.minute = 30
        
        dayOneSchedule = [Event(time: myCalendar.date(from: dateComponents)!,location: "Time Capsule",floor: 1, title: "Game Party",description: "Hanging out and playing games")]
        
        dayTwoSchedule = [Event(time: myCalendar.date(from: dateComponents1)!,location: "Time Capsule",floor: 1, title: "Lunch",description: "Hanging out and playing games"),
                          Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway",floor: 2, title: "Dinner",description: "Eating dinner"),
                          Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway",floor: 2, title: "Dinner",description: "Eating dinner")]
        
        dayThreeSchedule = [Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet",floor: 3, title: "Nothin",description: "Don't come"),
                            Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet",floor: 3, title: "Nothing happens on this floor I promise  Nothing happens on this floor I promise  Nothing happens on this floor I promise",description: "Don't come")]
        
    }
    
    
}

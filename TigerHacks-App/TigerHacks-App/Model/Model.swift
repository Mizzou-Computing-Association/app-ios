//
//  Model.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
class Model {
    static var sharedInstance = Model()

    private init() {
    }
    // Hex code for colors: FDFAE5

    var sponsors: [Sponsor]?
    var dayOneSchedule: [Event]?
    var dayTwoSchedule: [Event]?
    var dayThreeSchedule: [Event]?
    var beginnerPrizes: [Prize]?
    var mainPrizes: [Prize]?
    var resources: [Resource]?
    var fullSchedule: [Event]?
    let weekdayDict: [Int: String] = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]
    let youtubeAPIKey = "AIzaSyC13zJBGpl41NBWCasY7DZoVcM934hwcmI"
    let getRequestString = "GET https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=UUeKx_seoPvAs4vyXCdCmUGA&key=AIzaSyC13zJBGpl41NBWCasY7DZoVcM934hwcmI"
    let testGetRequestString =
    "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUIk5obDbG7wtFP6y-TyiJqQ&key=AIzaSyC13zJBGpl41NBWCasY7DZoVcM934hwcmI"
    let center = UNUserNotificationCenter.current()

    func fakeAPICall() {
        //Schedule Dummy Data

        let myCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 10
        dateComponents.day = 12
        dateComponents.hour = 20
        dateComponents.minute = 30
        var dateComponents1 = DateComponents()
        dateComponents1.year = 2018
        dateComponents1.month = 10
        dateComponents1.day = 13
        dateComponents1.hour = 12
        dateComponents1.minute = 00
        var dateComponents2 = DateComponents()
        dateComponents2.year = 2018
        dateComponents2.month = 10
        dateComponents2.day = 14
        dateComponents2.hour = 8
        dateComponents2.minute = 30
        var dateComponents3 = DateComponents()
        dateComponents3.year = 2018
        dateComponents3.month = 10
        dateComponents3.day = 14
        dateComponents3.hour = 1
        dateComponents3.minute = 30
        var dateComponents4 = DateComponents()
        dateComponents4.year = 2018
        dateComponents4.month = 10
        dateComponents4.day = 13
        dateComponents4.hour = 18
        dateComponents4.minute = 30

        // Test Dates for Notifications
        var testDateComponents = DateComponents()
        testDateComponents.year = 2018
        testDateComponents.month = 5
        testDateComponents.day = 15
        testDateComponents.hour = 13
        testDateComponents.minute = 54
        //Mentor Dummy Data

        let cernerMentors = [Mentor(name: "JJ Smith",
                                    skills: ["Computers", "Swift", "Objective C", "Eating Apples", "Nothing else",
                                             "That's it" ],
                                    contact: "U8E0F66QN")]

        //Sponsor Dummy Data

        sponsors = [Sponsor(mentors: nil,
                                        name: "AirBnb",
                                        description: "we find homes that you can rent. Undercut the hotels",
                                        website: "airbnb.com",
                                        location: "Table 5, Main Hallway",
                                        image: UIImage(named: "airbnb")),
                                Sponsor(mentors: cernerMentors,
                                        name: "Cerner",
                                        description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",
                                        website: "Cerner.com",
                                        location: "Table 6, Main Hallway",
                                        image: UIImage(named: "cerner")),
                                Sponsor(mentors: nil,
                                        name: "Google",
                                        description: "we google stuff all day",
                                        website: "google.com",
                                        location: "Table 7, Main Hallway",
                                        image: UIImage(named: "google")),
                                Sponsor(mentors: nil,
                                        name: "Pied Piper",
                                        description: "Compression software haha rfelevant topical joke software",
                                        website: "There is no website",
                                        location: "Table 8, Main Hallway",
                                        image: UIImage(named: "piedpiper")),
                                Sponsor(mentors: nil,
                                        name: "Microsoft",
                                        description: "we bing stuff all day",
                                        website: "bing.com",
                                        location: "Table 9, Main Hallway",
                                        image: UIImage(named: "microsoft")),
                                Sponsor(mentors: nil,
                                        name: "FulcrumGT",
                                        description: nil,
                                        website: nil,
                                        location: nil,
                                        image: nil),
                                Sponsor(mentors: nil,
                                        name: "Fulcrum GT",
                                        description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                        website: "dogfood.org",
                                        location: "Table 10, Main Hallway",
                                        image: UIImage(named: "fulcrumgt")),
                                Sponsor(mentors: nil,
                                        name: "Fulcrum GT",
                                        description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                        website: "dogfood.org",
                                        location: "Table 10, Main Hallway",
                                        image: UIImage(named: "fulcrumgt")),
                                Sponsor(mentors: nil,
                                        name: "Fulcrum GT",
                                        description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                        website: "dogfood.org",
                                        location: "Table 10, Main Hallway",
                                        image: UIImage(named: "fulcrumgt")),
                                Sponsor(mentors: nil,
                                        name: "Fulcrum GT",
                                        description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                        website: "dogfood.org",
                                        location: "Table 10, Main Hallway",
                                        image: UIImage(named: "fulcrumgt"))]
        //Prize Dummy Data
        beginnerPrizes = [
            Prize(sponsor:
                Sponsor(mentors: nil,
                        name: "Cerner",
                        description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",
                        website: "Cerner.com",
                        location: "Table 6, Main Hallway",
                        image: nil),
                  title: "Beginner Prize",
                  reward: "Nothing",
                  description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                  prizeType: PrizeType.Beginner),
            Prize(sponsor:
                Sponsor(mentors: nil,
                        name: "Cerner",
                        description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",
                        website: "Cerner.com",
                        location: "Table 6, Main Hallway",
                        image: nil),
                  title: "Beginner Prize",
                  reward: "Something",
                  description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                  prizeType: PrizeType.Beginner)]

        mainPrizes = [
            Prize(sponsor:
                Sponsor(mentors: nil,
                        name: "Cerner",
                        description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",
                        website: "Cerner.com",
                        location: "Table 6, Main Hallway",
                        image: nil),
                  title: "Make the World Better for us",
                  reward: "4 trips to a Cerner sponsored hospital facility",
                  description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                  prizeType: PrizeType.Main),
            Prize(sponsor:
                Sponsor(mentors: nil, name: "RJI", description: "we write articles blah blah blah", website: "Cerner.com", location: "Table 7, Main Hallway", image: nil),
                  title: "Do Something for the J-School",
                  reward: "A big ol' drone",
                  description: "You better do this one",
                  prizeType: PrizeType.Main),
            Prize(sponsor:
                Sponsor(mentors: nil, name: "Google", description: "we google stuff but really its just bing", website: "google.com/careers", location: "Table 99, Main Hallway", image: nil),
                  title: "Snooping For Google",
                  reward: "A google home wink wink",
                  description: "This prize is awarded to the hack that best encompasses Google's mission statement to farm as much information about literally everyone",
                  prizeType: PrizeType.Main),
            Prize(sponsor:
                Sponsor(mentors: nil,
                        name: "Microsoft",
                        description: "we search stuff but also computers. Really everything",
                        website: "microsoft.com/careers",
                        location: "Table 10, Main Hallway",
                        image: nil),
                  title: "Figure out PageRank",
                  reward: "We'll hire you",
                  description: "This prize is awarded to the hack that best figures out how the hell Google is ranking all those pages",
                  prizeType: PrizeType.Main)]

        //Resource Dummy Data
        resources = [
            Resource(url: "https://www.google.com", title: "Google", description: "It's a website for googling things that you should use probably a whole lot."),
            Resource(url: "https://www.bing.com", title: "Bing", description: "It's a website for binging things that you should use probably not a whole lot."),
            Resource(url: "https://www.yahoo.com", title: "Yahoo", description: "It's a website for yahooing (sp?) things that you should use probably not a whole lot."),
            Resource(url: "https://www.youtube.com/embed/RmHqOSrkZnk", title: "Embedding Videos into a WebView Tutorial", description: "Tutorial for embedding youtube videos into an iOS app. ")]

        //Schedule Dummy Data
        fullSchedule = [Event(time: myCalendar.date(from: dateComponents)!,
                              location: "The Time Capsule (W0009-Basement)",
                              floor: 1,
                              title: "Game Party",
                              description: "Hanging out and playing games"),
                        Event(time: myCalendar.date(from: dateComponents1)!,
                              location: "Time Capsule",
                              floor: 1,
                              title: "Lunch",
                              description: "Hanging out and playing games"),
                        Event(time: myCalendar.date(from: dateComponents1)!,
                              location: "Main Hallway",
                              floor: 2,
                              title: "Dinner",
                              description: "Eating dinner"),
                        Event(time: myCalendar.date(from: dateComponents4)!,
                              location: "Main Hallway",
                              floor: 2,
                              title: "Dinner",
                              description: "Eating dinner"),
                        Event(time: myCalendar.date(from: dateComponents2)!,
                              location: "The Closet",
                              floor: 3,
                              title: "Nothin",
                              description: "Don't come"),
                        Event(time: myCalendar.date(from: dateComponents3)!,
                              location: "The Closet",
                              floor: 3,
                              title: "Nothing happens on this floor I promise  Nothing happens on this floor I promise  Nothing happens on this floor",
                              description: "Don't come"),
                        Event(time: myCalendar.date(from: testDateComponents)!,
                              location: "Mizzou",
                              floor: 1,
                              title: "Test Notification",
                              description: "Don't come")]
        fullSchedule = sortEvents(events: fullSchedule)

        // Scheduling Notifications
        center.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.center.requestAuthorization(completionHandler: { (success, _) in
                    guard success else { return }
                    self.scheduleNotifications()
                })
            case .authorized:
                self.scheduleNotifications()
            case .denied:
                print("denied")
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                self.scheduleNotifications()
            }
        }
    }

// MARK: - JSON Loading and Parsing for Youtube TigerTalks
    func youtubeLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([YoutubeSnippet]?, String?) -> Void) {

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session

        guard let url = URL(string: testGetRequestString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(nil, "the url for requesting a channel is invalid")
            })
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil, let data = data else {
                var errorString = "data not available for requested channel "
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(nil, errorString)
                })
                return
            }

            let (snippets, errorString) = self.youtubeParse(with: data)

            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(snippets, nil)
                })
            }
        }

        task.resume()
    }

    func youtubeParse(with data: Data) -> ([YoutubeSnippet]?, String?) {
        var snippets = [YoutubeSnippet]()

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String: Any] else {
                return (nil, "unable to parse response from server")
        }

        if let items = rootNode["items"] as? [[String: Any]] {
            for item in items {
                if let snippetNode = item["snippet"] as? [String: Any],
                    let snippetTitle = snippetNode["title"] as? String,
                    let snippetDescription = snippetNode["description"] as? String,
                    let resourceNode = snippetNode["resourceId"] as? [String: Any],
                    let videoId = resourceNode["videoId"] as? String {

                    let resourceId = YoutubeResourceID(videoId: videoId)
                    let snippet = YoutubeSnippet(title: snippetTitle, description: snippetDescription, resourceId: resourceId )

                    snippets.append(snippet)
                }
            }
        }
        return (snippets, nil)
    }

    func scheduleNotifications() {
        for event in fullSchedule! {
            center.add(event.request) { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    print("THERE WAS AN ERROR")
                }
            }
        }
    }

// MARK: - Gradient color

    func setBarGradient(navigationBar: UINavigationBar) {
        navigationBar.setBackgroundImage(Model.sharedInstance.setGradientImageNavBar(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }

    func setGradientImageNavBar() -> UIImage {

        //Color is here 251    248    227
        let colorsMove = [
            UIColor(red: 251.0/255.0, green: 248.0/255.0, blue: 227.0/255.0, alpha: 1.0),
            UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        var gradientImageMove = UIImage()
        //Set the stopping point of each color of the gradient
        let locations = [0.55, 1]
        if DeviceType.IS_IPHONE_X {
            gradientImageMove = UIImage.convertGradientToImage(colors: colorsMove, frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 88), locations: locations)
        } else {
            gradientImageMove = UIImage.convertGradientToImage(colors: colorsMove, frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 64), locations: locations)
        }
        return gradientImageMove
    }

    func setGradientImageTabBar() -> UIImage {
        let colorsMove = [
        UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0),
        UIColor(red: 251.0/255.0, green: 248.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        var gradientImageMove = UIImage()
        let locations = [0.0, 0.6]
        if DeviceType.IS_IPHONE_X {
            gradientImageMove = UIImage.convertGradientToImage(colors: colorsMove, frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 88), locations: locations)
        } else {
            gradientImageMove = UIImage.convertGradientToImage(colors: colorsMove, frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 64), locations: locations)
        }
        return gradientImageMove
    }

    // MARK: - Sort Schedule Events

    func sortEvents(events: [Event]?) -> [Event]? {
        guard let events = events else { return nil }
        return events.sorted(by: { $0.time < $1.time })
    }
}

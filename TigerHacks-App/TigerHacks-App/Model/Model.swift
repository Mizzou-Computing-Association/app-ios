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
    let options: UNAuthorizationOptions = [.alert, .sound]
    let defaults = UserDefaults.standard

    func fakeAPICall() {
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
        
        //Resource Dummy Data
        resources = [
            Resource(url: "https://www.google.com", title: "Google", description: "It's a website for googling things that you should use probably a whole lot."),
            Resource(url: "https://www.bing.com", title: "Bing", description: "It's a website for binging things that you should use probably not a whole lot."),
            Resource(url: "https://www.yahoo.com", title: "Yahoo", description: "It's a website for yahooing (sp?) things that you should use probably not a whole lot."),
            Resource(url: "https://www.youtube.com/embed/RmHqOSrkZnk", title: "Embedding Videos into a WebView Tutorial", description: "Tutorial for embedding youtube videos into an iOS app. ")]
    }
    
// MARK: - Schedule Notifications
    
    func checkNotificationPermissions() {
        center.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                print("Not Determined")
                self.center.requestAuthorization(options: self.options, completionHandler: { (success, _) in
                    guard success else { print("failure");return }
                    print("success")
                    self.scheduleNotifications()
                })
            case .authorized:
                print("Authorized")
                self.scheduleNotifications()
            case .denied:
                print("denied")
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                print("Provisional")
                self.scheduleNotifications()
            }
        }
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
        defaults.set(true, forKey: "Scheduled")
    }
    
// MARK: - JSON Loading and Parsing for Prizes
    func prizeLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Prize]?, String?) -> Void) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let requestString = "https://n61dynih7d.execute-api.us-east-2.amazonaws.com/production/tigerhacksPrizes"
        
        guard let url = URL(string: requestString) else {
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
            print(data)
            let (prizes, errorString) = self.prizeParse(with: data)

            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(prizes, nil)
                })
            }
        }
        
        task.resume()
    }
    
    func prizeParse(with data: Data) -> ([Prize]?, String?) {
        var prizes = [Prize]()
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String: Any] else {
                return (nil, "unable to parse response from server")
        }
        
        print("JSON: \(json)")
        
        if let items = rootNode["prizes"] as? [[String: Any]] {
            for item in items {
                print("ITEM: \(item)")
                if let prizeSponsorID = item["Sponsor"] as? Int,
                    let prizeTitle = item["Title"] as? String,
                    let prizeReward = item["Reward"] as? String,
                    let prizeDescription = item["Description"] as? String,
                    let prizeType = item["Prizetype"] as? String,
                    let enumPrizeType = PrizeType(rawValue: prizeType) {
                    print("all the if lets worked~~~~~~~~~~~~~~~~~~~")
                    
                    let prize = Prize(sponsorID: prizeSponsorID, title: prizeTitle, reward: prizeReward, description: prizeDescription, prizeType: enumPrizeType)
                    
                    prizes.append(prize)
                }
            }
        }
        return (prizes, nil)
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
    
// MARK: - JSON Loading and Parsing for Schedule Events
    func scheduleLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Event]?, String?) -> Void) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let requestString = "https://n61dynih7d.execute-api.us-east-2.amazonaws.com/production/tigerhacksSchedule"
        
        guard let url = URL(string: requestString) else {
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
            
            let (events, errorString) = self.scheduleParse(with: data)
            
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(events, nil)
                })
            }
        }
        
        task.resume()
    }
    
    func scheduleParse(with data: Data) -> ([Event]?, String?) {
        var events = [Event]()
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String: Any] else {
                return (nil, "unable to parse response from server")
        }
        
        if let items = rootNode["schedule"] as? [[String: Any]] {
            for item in items {
                if let eventTime = item["Time"] as? String,
                    let eventTitle = item["Title"] as? String,
                    let eventLocation = item["Location"] as? String,
                    let eventDescription = item["Description"] as? String,
                    let eventFloor = item["Floor"] as? Int {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                    
                    if let date = dateFormatter.date(from: eventTime) {
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                        if let finalDate = calendar.date(from: components) {
                            let event = Event(time: finalDate, location: eventLocation, floor: eventFloor, title: eventTitle, description: eventDescription)
                            events.append(event)
                        }
                    }
                }
            }
        }
        fullSchedule = sortEvents(events: fullSchedule)
        return (events, nil)
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

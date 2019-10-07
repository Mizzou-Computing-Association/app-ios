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
class Model {
    static var sharedInstance = Model()

    private init() {
    }
    // Hex code for colors: FDFAE5

    var dayOneSchedule: [Event]?
    var dayTwoSchedule: [Event]?
    var dayThreeSchedule: [Event]?
    var beginnerPrizes: [Prize]?
    var mainPrizes: [Prize]?
    var resources: [Resource]?
    var fullSchedule: [Event]?
    
    let weekdayDict: [Int: String] = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]
    
    let getRequestString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=UUeKx_seoPvAs4vyXCdCmUGA&key=AIzaSyC13zJBGpl41NBWCasY7DZoVcM934hwcmI"
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    func fakeAPICall() {
        //Resource Dummy Data
        resources = [
            Resource(url: "http://tigerhacks.missouri.edu", title: "TigerHacks Site", description: ""),
            Resource(url: "https://join.slack.com/t/tigerhacks2018/shared_invite/enQtNDUwNTU1MTg3OTA5LWQ4NDNkOWJhMWNlNjM4NGIwZWE1NTEzZmZhOGE4MjRiMTM4NzA1ODYzMjZiZWQ0NmRkMTM4ZDYyYjMxZTM1NTY", title: "Join the Slack", description: ""),
            Resource(url: "https://tigerhacks-2018.devpost.com", title: "Devpost", description: ""),
            Resource(url: "https://twitter.com/tigerhackshd", title: "Twitter", description: ""),
            Resource(url: "https://www.instagram.com/tigerhacks/", title: "Instagram", description: ""),
            Resource(url: "https://www.facebook.com/TigerHacks/", title: "Facebook", description: "")]
    }
    
// MARK: - Schedule Notifications
    
    func scheduleNotifications() {
        center.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                print("Not Determined")
                self.center.requestAuthorization(options: self.options, completionHandler: { (success, _) in
                    guard success else { print("failure");return }
                    print("success")
                    self.addNotifications()
                })
            case .authorized:
                print("Authorized")
                self.addNotifications()
            case .denied:
                print("denied")
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                print("Provisional")
                self.addNotifications()
            }
        }
    }
    func addNotifications() {
        center.removeAllPendingNotificationRequests()
            for event in fullSchedule! {
                center.add(event.request) { (error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        print("THERE WAS AN ERROR")
                    }
                }
            }
        
    }
    
    func dowloadImage(imageString: String, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard let imageUrl = URL(string: imageString) else {
            print("Could not make image url")
            return
        }
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: imageUrl) { (data, response, error) in
            // The download has finished.
            if let error = error {
                print("Error downloading picture: \(error)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        if let finalImage = UIImage(data: imageData) {
                            dispatchQueueForHandler.async(execute: {
                                completionHandler(finalImage, nil)
                            })
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    func sponsorsLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Sponsor]?, String?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let requestString = "https://tigerhacks.com/api/sponsors"
        
        guard let url = URL(string: requestString) else {
            dispatchQueueForHandler.async {
                completionHandler(nil, "the url for requesting a channel is invalid" )
            }
            return
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        let task =  session.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil, let data = data else {
                var errorString = "data not available for requested channel"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(nil, errorString)
                })
                return
            }
            print(data)
            
//            let jsonData = data //String(data: data, encoding: .utf8)
            
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                let rootNode = json as? [String: Any] else {
//                    completionHandler(nil, "unable to parse response from server")
//            }
//
//            print("JSON: \(json)")
//
            let sponsorsObject = try? JSONDecoder().decode(SponsorResponse.self, from: data)
            
            dispatchQueueForHandler.async(execute: {
                completionHandler(sponsorsObject?.sponsors, nil)
            })

        }
        task.resume()
    }
    
    func prizeLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Prize]?, String?) -> Void) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let requestString = "https://n61dynih7d.execute-api.us-east-2.amazonaws.com/production/tigerhacksNewPrizes"
        
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
            let items = json as? [[String: Any]] else {
                return (nil, "unable to parse response from server")
        }
        
        print("JSON: \(json)")
        
        for item in items {
            print("ITEM: \(item)")
            if let prizeSponsorID = item["sponsor"] as? String,
                let prizeTitle = item["title"] as? String,
                let prizeReward = item["reward"] as? String,
                let prizeDescription = item["description"] as? String,
                let prizeType = item["prizetype"] as? String,
                let enumPrizeType = PrizeType(rawValue: prizeType) {
                print("all the if lets worked~~~~~~~~~~~~~~~~~~~")
                
                let prize = Prize(sponsorID: prizeSponsorID, title: prizeTitle, reward: prizeReward, description: prizeDescription, prizeType: enumPrizeType)
                
                prizes.append(prize)
            }
        }
        return (prizes, nil)
    }

// MARK: - JSON Loading and Parsing for Youtube TigerTalks
    func youtubeLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([YoutubeSnippet]?, String?) -> Void) {

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session

        guard let url = URL(string: getRequestString) else {
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
        let requestString = "https://tigerhacks.com/api/schedule"
        
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
            let items = json as? [[String: Any]] else {
                return (nil, "unable to parse response from server")
        }
        
        for item in items {
            if let eventTime = item["time"],
                let eventTitle = item["title"] {
                let eventLocation = item["location"] ?? " "
                let eventDescription = item["description"] ?? " "
                
                if let eventTime = eventTime as? Double,
                    let eventTitle = eventTitle as? String,
                    let eventLocation = eventLocation as? String,
                    let eventDescription = eventDescription as? String {
                    
                    let date = Date(timeIntervalSince1970: eventTime/1000)
                    
                    let event = Event(time: date, day: 0, location: eventLocation, floor: 0, title: eventTitle, description: eventDescription)
                    print("Event: " + String(describing: event))
                    events.append(event)
                    
                }
                
            }
        }
        
        fullSchedule = sortEvents(events: fullSchedule)
        return (events, nil)
    }

    // MARK: - Sort Schedule Events
    func sortEvents(events: [Event]?) -> [Event]? {
        guard let events = events else { return nil }
        return events.sorted(by: { $0.time < $1.time })
    }
}

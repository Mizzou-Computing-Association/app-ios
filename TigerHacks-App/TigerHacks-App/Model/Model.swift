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
import FirebaseAuth
import MapKit
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
	var profile: Profile?
    
    let weekdayDict: [Int: String] = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]
    
    let getRequestString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=UUeKx_seoPvAs4vyXCdCmUGA&key=AIzaSyC13zJBGpl41NBWCasY7DZoVcM934hwcmI"
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    func fakeAPICall() {
        //Resource Dummy Data
        resources = [
            Resource(url: "http://tigerhacks.missouri.edu", title: "TigerHacks Site", description: ""),
            Resource(url: "https://join.slack.com/t/tigerhacks2019/shared_invite/enQtNzg3ODQxMjQyNDg2LWExZTIyNWQ1ZThlMGRhMzAwNjQ4MGEwZDhhMmQxNTUwMTcyOGZiNjAxNzFkN2IzZjQxMDhhZGI5ZmFlMzkxMWQ", title: "Join the Slack", description: ""),
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
        print("Sponsors Load")
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
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let rootNode = json as? [String: [[String: Any]]] else {
                    completionHandler(nil, "unable to parse response from server")
                    return
            }

            print("JSON: \(json)")
            var sponsors = [Sponsor]()
            
            for (_, item) in rootNode {
                for realItem in item {
                    if let name = realItem["name"],
                        let description = realItem["description"],
                        let level = realItem["level"],
                        let image = realItem["image"],
                        let website = realItem["website"] {

                        if let description = description as? String,
                            let name = name as? String,
                            let image = image as? String,
                            let level = level as? String,
                            let website = website as? String {
                            
                            var realMentors = [Mentor]()
                            let mentors = realItem["mentors"]
                            
                            if let mentors = mentors as? [[String: String]] {
                                for mentor in mentors {
                                    print(mentor)
                                    if let mentorName = mentor["name"],
                                        let skills = mentor["skills"],
                                        let contact = mentor["contact"] {
                                        print("making mentor")
                                        let skillsArray = skills.components(separatedBy: ",")
                                        realMentors.append(Mentor(name: mentorName, skills: skillsArray, contact: contact))
                                        
                                    }
                                }
                            }
                           
                            let sponsor = Sponsor(mentors: realMentors, name: name, description: description, website: website, image: nil, imageUrl: image, level: Int(level)!)
                            print("Real Mentors: \(realMentors)")
                            
                            sponsors.append(sponsor)
                        }
                    }
                }
                
            }
            
            dispatchQueueForHandler.async(execute: {
                completionHandler(sponsors, nil)
            })

        }
        task.resume()
    }
    
    func prizeLoad(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Prize]?, String?) -> Void) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let requestString = "https://tigerhacks.com/api/prizes"
        
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
        print("Starting prize parse")
        var prizes = [Prize]()
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let items = json as? [String: [[String: Any]]] else {
                return (nil, "unable to parse response from server")
        }
        
        for (catName, category) in items {
            print(catName)
            for prize in category {
                print(prize)
                if let prizeTitle = prize["title"] as? String,
                    let prizeReward = prize["reward"] as? String,
                    let prizeDescription = prize["description"] as? String,
                    let prizeType = prize["prizeType"] as? String,
                    let order = prize["order"] as? Int {
                    
                    if let enumPrizeType = PrizeType(rawValue: catName) {
                        let prizeSponsorID = prize["sponsor"] as? String 
                        let prize = Prize(sponsorID: prizeSponsorID, title: prizeTitle, reward: prizeReward, description: prizeDescription, prizeType: enumPrizeType, order: order)
                            prizes.append(prize)
                    } else {
                        print("enum prizeType bad")
                        print(prizeType)
                    }
                } else {
                    print("if let failing")
                }
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
        print("Starting Schedule Parse")
        var events = [Event]()
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let items = json as? [String: [[String: Any]]] else {
                return (nil, "unable to parse response from server")
        }
        
        for (_, item) in items {
            if let realItem = item.first,
                let eventTime = realItem["time"],
                let eventTitle = realItem["title"] {
                let eventLocation = realItem["location"] ?? " "
                let eventDescription = realItem["description"] ?? " "
                let eventLat = realItem["lat"] as? Double
                let eventLong = realItem["long"] as? Double
                
                var eventCoords: CLLocationCoordinate2D?
//                print(eventLat)
//                print(eventLong)
                
                if let eventLat = eventLat,
                    let eventLong = eventLong {
                    eventCoords = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
                    print(eventCoords)
                }
                
                if let eventTime = eventTime as? String,
                    let eventTitle = eventTitle as? String,
                    let eventLocation = eventLocation as? String,
                    let eventDescription = eventDescription as? String {

//                    let date = Date(timeIntervalSince1970: eventTime/1000)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let date = dateFormatter.date(from: eventTime) {
                        let event = Event(time: date, day: 0, location: eventLocation, floor: 0, title: eventTitle, description: eventDescription, coords: eventCoords)
                        events.append(event)
                    } else {
                        print("date no work")
                    }

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

	func getProfile(_ callback: @escaping (Profile?) -> Void) {
		if let user = Auth.auth().currentUser {
			URLSession.shared.dataTask(with: URL(string: "https://tigerhacks.com/api/profile?userid=\(user.uid)")!) { data, _, _ in
				if let data = data {
					self.profile = try? JSONDecoder().decode(Profile.self, from: data)
					callback(self.profile)
				}
			}.resume()
		} else {
			self.profile = nil
			callback(profile)
		}
	}
}

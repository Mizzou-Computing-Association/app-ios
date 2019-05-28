//
//  AppDelegate.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//
// swiftlint:disable all

import UIKit
import CoreData
import CoreGraphics
import UserNotifications
import AWSSNS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let platformApplicationArn = Secrets.platformApplicationArn
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        //MARK: Pre-load schedule!
        Model.sharedInstance.scheduleLoad(dispatchQueueForHandler: DispatchQueue.main) {(events, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else if let events = events {
                
                var tempEvents = [Event]()
                for event in events {
                    let event = Event(time: event.time, location: event.location, floor: event.floor, title: event.title, description: event.description)
                    tempEvents.append(event)
                }
                
                Model.sharedInstance.fullSchedule = tempEvents
             
                //MARK: Notifications
                let center = UNUserNotificationCenter.current()
                print("Get Notification Approval")
                center.getNotificationSettings { (notificationSettings) in
                    switch notificationSettings.authorizationStatus {
                    case .notDetermined:
                        // Request Authorization
                        print("Not Determined AppDelegate")
                        center.requestAuthorization(options: Model.sharedInstance.options, completionHandler: { (success, _) in
                            guard success else { print("failure AppDelegate");return }
                            print("success AppDelegate")
                            Model.sharedInstance.scheduleNotifications()
                        })
                    case .authorized:
                        print("Authorized")
                        Model.sharedInstance.scheduleNotifications()
                    case .denied:
                        print("denied")
                        print("Application Not Allowed to Display Notifications")
                    case .provisional:
                        print("Provisional")
                        Model.sharedInstance.scheduleNotifications()
                    }
                }    
            }
        }
        
        // Make Request to APNS
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            guard granted else {
                return
            }
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:Secrets.identityPoolId)
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Get Token ENDPOINT
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        //Create SNS Module
        let sns = AWSSNS.default()
        let request = AWSSNSCreatePlatformEndpointInput()
        request?.token = deviceTokenString
        
        //Send Request
        request?.platformApplicationArn = platformApplicationArn
        
        sns.createPlatformEndpoint(request!).continueWith(block: { (task: AWSTask!) -> AnyObject? in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                
                let createEndpointResponse = task.result! as AWSSNSCreateEndpointResponse
                print("endpointArn: \(createEndpointResponse.endpointArn)")
                
                let subscription = Secrets.subscriptionArn
                //Create Subscription request
                let subscriptionRequest = AWSSNSSubscribeInput()
                
                
                subscriptionRequest?.protocols = "application"
                subscriptionRequest?.topicArn = subscription
                subscriptionRequest?.endpoint = createEndpointResponse.endpointArn
                
                sns.subscribe(subscriptionRequest!).continueWith (block: {
                    (task:AWSTask) -> AnyObject? in
                    if task.error != nil {
                        print("Error subscribing: \(task.error)")
                        return nil
                    }
                    
                    print("Subscribed succesfully")
                    
                    //Confirm subscription
                    let subscriptionConfirmInput = AWSSNSConfirmSubscriptionInput()
                    subscriptionConfirmInput?.token = createEndpointResponse.endpointArn
                    subscriptionConfirmInput?.topicArn = subscription
                    sns.confirmSubscription(subscriptionConfirmInput!).continueWith (block: {
                        (task:AWSTask) -> AnyObject? in
                        if task.error != nil {
                            print("Error subscribing: \(task.error)")
                        }
                        return nil
                    })
                    return nil
                    
                })
                
            }
            return nil
            
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let alert = UIAlertController(title: "A Message From The Organizers:\n", message: notification.request.content.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ", response.notification.request.content.userInfo)
        completionHandler()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TigerHacks_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

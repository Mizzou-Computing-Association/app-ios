//
//  ScheduleViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var daySwitcher: UISegmentedControl!

    var fullSchedule: [Event] = []
    var dayOneArray: [Event] = []
    var dayTwoArray: [Event] = []
    var dayThreeArray: [Event] = []
    var refreshControl: UIRefreshControl!

    let dateFormatter = DateFormatter()
    let longDateFormatter = DateFormatter()

    let date1 = "10/12/2018"
    let date2 = "10/13/2018"
    let date3 = "10/14/2018"

    override func viewDidLoad() {
        super.viewDidLoad()
        //Initial Setup
        self.setUpNavBar()
        dateFormatter.timeStyle = .short
        longDateFormatter.timeZone = TimeZone.current
        longDateFormatter.dateFormat = "MM/dd/yyyy"
        loadSchedules()
        setDay()
        
        // Swipe To Change Day
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        //Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        scheduleTableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// MARK: - Load Schedules
    
    func loadSchedules() {
        Model.sharedInstance.scheduleLoad(dispatchQueueForHandler: DispatchQueue.main) {(events, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else if let events = events {
                self.fullSchedule = events
                var tempEvents = [Event]()
                for event in events {
                    let event = Event(time: event.time, day: event.day, location: event.location, floor: event.floor, title: event.title, description: event.description)
                    tempEvents.append(event)
                }
                self.fullSchedule = tempEvents
                self.fullSchedule = Model.sharedInstance.sortEvents(events: self.fullSchedule)!
                Model.sharedInstance.fullSchedule = self.fullSchedule
                self.divideEventsByDay()
                Model.sharedInstance.scheduleNotifications()
                self.scheduleTableView.reloadData()
            }
        }
    }
    
    @objc func refresh(_ sender: Any) {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadSchedules()
            self.refreshControl.endRefreshing()
            self.scheduleTableView.reloadData()
        }
    }

    func divideEventsByDay() {
        var tempDayOneArray = [Event]()
        var tempDayTwoArray = [Event]()
        var tempDayThreeArray = [Event]()

        for event in fullSchedule {
            let stringDate = longDateFormatter.string(from: event.time)
            if stringDate.compare(date1) == .orderedSame {
                tempDayOneArray.append(event)
            } else if stringDate.compare(date2) == .orderedSame {
                tempDayTwoArray.append(event)
            } else if stringDate.compare(date3) == .orderedSame {
                tempDayThreeArray.append(event)
            }
        }

        dayOneArray = tempDayOneArray
        dayTwoArray = tempDayTwoArray
        dayThreeArray = tempDayThreeArray
    }

// MARK: - Default Starting Day

    func setDay() {

        let currentDate = longDateFormatter.string(from: Date())

        if currentDate.compare(date1) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 0
        } else if currentDate.compare(date2) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 1
        } else if currentDate.compare(date3) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 2
        } else {
            daySwitcher.selectedSegmentIndex = 0
        }
        scheduleTableView.reloadData()
    }

// MARK: - Nav Bar Gradient

    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
        //Tab bar
        tabBarController?.tabBar.backgroundImage = Model.sharedInstance.setGradientImageTabBar()
        tabBarController?.tabBar.shadowImage =  UIImage()
    }

// MARK: - Change Day

    @IBAction func changeDay(_ sender: UISegmentedControl) {
        scheduleTableView.reloadData()
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {return}

        switch swipeGesture.direction {
        case .left:
            if daySwitcher.selectedSegmentIndex == 0 {
                daySwitcher.selectedSegmentIndex = 1
                scheduleTableView.reloadData()
            } else if daySwitcher.selectedSegmentIndex == 1 {
                daySwitcher.selectedSegmentIndex = 2
                scheduleTableView.reloadData()
            }
        case .right:
            if daySwitcher.selectedSegmentIndex == 2 {
                daySwitcher.selectedSegmentIndex = 1
                scheduleTableView.reloadData()
            } else if daySwitcher.selectedSegmentIndex == 1 {
                daySwitcher.selectedSegmentIndex = 0
                scheduleTableView.reloadData()
            }
        default:
            break
        }

    }

// MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch daySwitcher.selectedSegmentIndex {
        case 0 :
            return dayOneArray.count
        case 1 :
            return dayTwoArray.count
        case 2 :
            return dayThreeArray.count
        default :
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ScheduleTableViewCell

        switch daySwitcher.selectedSegmentIndex {
        case 0:
            cell.eventLabel.text = dayOneArray[indexPath.row].title
            cell.locationLabel.text = dayOneArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: dayOneArray[indexPath.row].time)
        case 1:
            cell.eventLabel.text = dayTwoArray[indexPath.row].title
            cell.locationLabel.text = dayTwoArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: dayTwoArray[indexPath.row].time)
        case 2:
            cell.eventLabel.text = dayThreeArray[indexPath.row].title
            cell.locationLabel.text = dayThreeArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: dayThreeArray[indexPath.row].time)
        default:
            cell.eventLabel.text = "There is NO Event"
            cell.locationLabel.text = "Who Knows Where"
            cell.timeLabel.text = "No Time"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventSegue", sender: self)
        scheduleTableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EventDetailViewController
        guard let selectedRow = scheduleTableView.indexPathForSelectedRow else {return}

        //Assign Values to any fields in Event Detail

        if daySwitcher.selectedSegmentIndex == 0 {
            destination.titleText = dayOneArray[selectedRow.row].title
            destination.locationText = dayOneArray[selectedRow.row ].location
            destination.timeText = dateFormatter.string(from: dayOneArray[selectedRow.row].time)
            destination.descriptionText = dayOneArray[selectedRow.row].description
        } else if daySwitcher.selectedSegmentIndex == 1 {
            destination.titleText = dayTwoArray[selectedRow.row].title
            destination.locationText = dayTwoArray[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: dayTwoArray[selectedRow.row].time)
            destination.descriptionText = dayTwoArray[selectedRow.row].description
        } else {
            destination.titleText = dayThreeArray[selectedRow.row].title
            destination.locationText = dayThreeArray[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: dayThreeArray[selectedRow.row].time)
            destination.descriptionText = dayThreeArray[selectedRow.row].description
        }
    }
}

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
    var testDayOneArray: [Event] = []
    var testDayTwoArray: [Event] = []
    var testDayThreeArray: [Event] = []
    var refreshControl: UIRefreshControl!
    
    let dateFormatter = DateFormatter()
    let longDateFormatter = DateFormatter()
    
    let date1 = "10/12/2018"
    let date2 = "10/13/2018"
    let date3 = "10/14/2018"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial Setup

        Model.sharedInstance.fakeAPICall()
        self.setUpNavBar()
        dateFormatter.timeStyle = .short
        longDateFormatter.timeZone = TimeZone.current
        longDateFormatter.dateFormat = "MM/dd/yyyy"
        loadSchedules()
        
        // Swipe To Change Day
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        //Refresh Control
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        scheduleTableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Load Schedules
    
    func loadSchedules() {
        fullSchedule = Model.sharedInstance.fullSchedule!
        divideEventsByDay()
//        testDayOneArray = Model.sharedInstance.dayOneSchedule!
//        testDayTwoArray = Model.sharedInstance.dayTwoSchedule!
//        testDayThreeArray = Model.sharedInstance.dayThreeSchedule!
    }
    
    @objc func refresh(_ sender:Any) {
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
            }else if stringDate.compare(date2) == .orderedSame {
                tempDayTwoArray.append(event)
            }else if stringDate.compare(date3) == .orderedSame {
                tempDayThreeArray.append(event)
            }
        }
        
        testDayOneArray = tempDayOneArray
        testDayTwoArray = tempDayTwoArray
        testDayThreeArray = tempDayThreeArray
    }
    
// MARK: - Default Starting Day
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDay()
    }
    
    func setDay() {

        let currentDate = longDateFormatter.string(from: Date())
        
        if currentDate.compare(date1) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 0
        } else if currentDate.compare(date2) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 1
        } else if currentDate.compare(date3) == .orderedSame {
            daySwitcher.selectedSegmentIndex = 2
        }else {
            daySwitcher.selectedSegmentIndex = 0
        }
        scheduleTableView.reloadData()
    }
    
// MARK: - Nav Bar Gradient
    
    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
        //Tab bar
        tabBarController?.tabBar.backgroundImage = Model.sharedInstance.setGradientImageTabBar()
        tabBarController?.tabBar.shadowImage =  UIImage();
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
            }else if daySwitcher.selectedSegmentIndex == 1 {
                daySwitcher.selectedSegmentIndex = 2
                scheduleTableView.reloadData()
            }
        case .right:
            if daySwitcher.selectedSegmentIndex == 2{
                daySwitcher.selectedSegmentIndex = 1
                scheduleTableView.reloadData()
            }else if daySwitcher.selectedSegmentIndex == 1 {
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
            return testDayOneArray.count
        case 1 :
            return testDayTwoArray.count
        case 2 :
            return testDayThreeArray.count
        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ScheduleTableViewCell
        
        switch daySwitcher.selectedSegmentIndex {
        case 0:
            cell.eventLabel.text = testDayOneArray[indexPath.row].title
            cell.locationLabel.text = testDayOneArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: testDayOneArray[indexPath.row].time)
        case 1:
            cell.eventLabel.text = testDayTwoArray[indexPath.row].title
            cell.locationLabel.text = testDayTwoArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: testDayTwoArray[indexPath.row].time)
        case 2:
            cell.eventLabel.text = testDayThreeArray[indexPath.row].title
            cell.locationLabel.text = testDayThreeArray[indexPath.row].location
            cell.timeLabel.text = dateFormatter.string(from: testDayThreeArray[indexPath.row].time)
            print(dateFormatter.string(from: testDayThreeArray[indexPath.row].time))
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
            destination.titleText = testDayOneArray[selectedRow.row].title
            destination.locationText = testDayOneArray[selectedRow.row ].location
            destination.timeText = dateFormatter.string(from: testDayOneArray[selectedRow.row].time)
            destination.descriptionText = testDayOneArray[selectedRow.row].description
        }
        else if daySwitcher.selectedSegmentIndex == 1{
            destination.titleText = testDayTwoArray[selectedRow.row].title
            destination.locationText = testDayTwoArray[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: testDayTwoArray[selectedRow.row].time)
            destination.descriptionText = testDayTwoArray[selectedRow.row].description
        }
        else {
            destination.titleText = testDayThreeArray[selectedRow.row].title
            destination.locationText = testDayThreeArray[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: testDayThreeArray[selectedRow.row].time)
            destination.descriptionText = testDayThreeArray[selectedRow.row].description
        }
    }
}




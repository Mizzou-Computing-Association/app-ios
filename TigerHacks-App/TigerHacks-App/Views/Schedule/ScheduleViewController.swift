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
    
    var testDayOneArray: [Event] = []
    var testDayTwoArray: [Event] = []
    var testDayThreeArray: [Event] = []
    var refreshControl: UIRefreshControl!
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        //MARK: Setup, paste this where it is needed
        super.viewDidLoad()
        Model.sharedInstance.fakeAPICall()
        self.setUpNavBar()
        
        dateFormatter.timeStyle = .short
        
        testDayOneArray = Model.sharedInstance.dayOneSchedule!
        testDayTwoArray = Model.sharedInstance.dayTwoSchedule!
        testDayThreeArray = Model.sharedInstance.dayThreeSchedule!
        scheduleTableView.reloadData()
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        //Action triggered when table view pulled and released
        scheduleTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender:Any) {
        fetchEventData()
        //Fetch Event Data
    }
    
    func fetchEventData() {
        Model.sharedInstance.fakeAPICall()
        scheduleTableView.reloadData()
        self.refreshControl.endRefreshing()
        //Update user interface after fetch and end refreshing
    }
    //paste this
    func setUpNavBar() {
   
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)

        //Tab bar?
        tabBarController?.tabBar.backgroundImage = Model.sharedInstance.setGradientImageTabBar()
        
        //This pesky fucker won't go away wtf
        tabBarController?.tabBar.shadowImage =  UIImage();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    
    @IBAction func changeDay(_ sender: UISegmentedControl) {
        scheduleTableView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                
                if daySwitcher.selectedSegmentIndex == 0 {
                    daySwitcher.selectedSegmentIndex = 1
                    scheduleTableView.reloadData()
                }else if daySwitcher.selectedSegmentIndex == 1 {
                    daySwitcher.selectedSegmentIndex = 2
                    scheduleTableView.reloadData()
                }
            case UISwipeGestureRecognizerDirection.right:
                
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
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EventDetailViewController
        guard let selectedRow = scheduleTableView.indexPathForSelectedRow else{return}
        
        //Assign Values to any outlets in Event Detail
        
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




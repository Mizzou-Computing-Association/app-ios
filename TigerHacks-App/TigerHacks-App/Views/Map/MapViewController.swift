//
//  MapViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var floorSelector: UISegmentedControl!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var mapScrollView: UIScrollView!
    
    let testImageArray = [UIImage(named:"firstFloor"),UIImage(named:"secondFloor"),UIImage(named:"thirdFloor")]
    
    let myCalendar = Calendar.current
    
    var testEventArray = [Event]()
    var floorOneEvents = [Event]()
    var floorTwoEvents = [Event]()
    var floorThreeEvents = [Event]()
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        mapTableView.dataSource = self
        mapTableView.delegate = self
        mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
        self.mapScrollView.minimumZoomScale = 1.0
        self.mapScrollView.maximumZoomScale = 8.0
        
        Model.sharedInstance.fakeAPICall()
        testEventArray = Model.sharedInstance.fullSchedule!
        filterFullScheduleByFloor(fullSchedule: testEventArray)

        //Swipe to change level
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    
        //Taps
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        mapScrollView.addGestureRecognizer(tap)
        
        //Refresh
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        
        mapTableView.addSubview(refreshControl)
    }
    
    func filterFullScheduleByFloor(fullSchedule: [Event]) {
        var tempFloorOneEvents = [Event]()
        var tempFloorTwoEvents = [Event]()
        var tempFloorThreeEvents = [Event]()
        
        for event in fullSchedule {
            if event.floor == 1 {
                tempFloorOneEvents.append(event)
                
            }else if event.floor == 2 {
                tempFloorTwoEvents.append(event)
                
            }else if event.floor == 3 {
                tempFloorThreeEvents.append(event)
                
            }
        }
        
        floorOneEvents = tempFloorOneEvents
        floorTwoEvents = tempFloorTwoEvents
        floorThreeEvents = tempFloorThreeEvents
        mapTableView.reloadData()
    }
    
    func setUpNavBar() {
        
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeLevelOfMap(_ sender: UISegmentedControl) {
        
        mapScrollView.zoomScale = 1.0
        mapImageView.image = testImageArray[sender.selectedSegmentIndex]
        mapTableView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                
                if floorSelector.selectedSegmentIndex == 0 {
                    floorSelector.selectedSegmentIndex = 1
                    mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                    mapTableView.reloadData()
                }else if floorSelector.selectedSegmentIndex == 1 {
                    floorSelector.selectedSegmentIndex = 2
                    mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                    mapTableView.reloadData()
                }
            case UISwipeGestureRecognizerDirection.right:
                
                if floorSelector.selectedSegmentIndex == 2 {
                    floorSelector.selectedSegmentIndex = 1
                    mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                    mapTableView.reloadData()
                }else if floorSelector.selectedSegmentIndex == 1 {
                    floorSelector.selectedSegmentIndex = 0
                    mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                    mapTableView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        mapScrollView.setZoomScale(1.0, animated: true)
    }
    
    // MARK: - Tableview
    
    @objc func refresh(_ sender:Any) {
        fetchEventData()
    }
    
    func fetchEventData() {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.8
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.testEventArray = Model.sharedInstance.fullSchedule!
            self.filterFullScheduleByFloor(fullSchedule: self.testEventArray)
            self.refreshControl.endRefreshing()
            self.mapTableView.reloadData()
        }
    }
        
        
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events on This Floor"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch floorSelector.selectedSegmentIndex {
        case 0:
            
            return floorOneEvents.count
        case 1:
            
            return floorTwoEvents.count
        case 2:
            
            return floorThreeEvents.count
        default :
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        switch floorSelector.selectedSegmentIndex {
            case 0:
                cell.eventLabel.text = floorOneEvents[indexPath.row].title
                cell.locationLabel.text = floorOneEvents[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: floorOneEvents[indexPath.row].time)
            case 1:
                cell.eventLabel.text = floorTwoEvents[indexPath.row].title
                cell.locationLabel.text = floorTwoEvents[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: floorTwoEvents[indexPath.row].time)
            case 2:
                cell.eventLabel.text = floorThreeEvents[indexPath.row].title
                cell.locationLabel.text = floorThreeEvents[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: floorThreeEvents[indexPath.row].time)
            default:
                cell.eventLabel.text = "There is NO Event"
                cell.locationLabel.text = "Who Knows Where"
                cell.timeLabel.text = "No Time"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapEventDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EventDetailViewController
        guard let selectedRow = mapTableView.indexPathForSelectedRow else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        switch floorSelector.selectedSegmentIndex {
        case 0:
            destination.titleText = floorOneEvents[selectedRow.row].title
            destination.locationText = floorOneEvents[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: floorOneEvents[selectedRow.row].time)
            destination.descriptionText = floorOneEvents[selectedRow.row].description
        case 1:
            destination.titleText = floorTwoEvents[selectedRow.row].title
            destination.locationText = floorTwoEvents[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: floorTwoEvents[selectedRow.row].time)
            destination.descriptionText = floorTwoEvents[selectedRow.row].description
        case 2:
            destination.titleText = floorThreeEvents[selectedRow.row].title
            destination.locationText = floorThreeEvents[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: floorThreeEvents[selectedRow.row].time)
            destination.descriptionText = floorThreeEvents[selectedRow.row].description
        default:
            destination.titleText = "There is NO Event"
            destination.locationText = "Who Knows Where"
            destination.timeText = "No Time"
            destination.descriptionText = "No Description"
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

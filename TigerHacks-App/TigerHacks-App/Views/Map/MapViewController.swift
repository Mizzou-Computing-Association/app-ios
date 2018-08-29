//
//  MapViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var floorSelector: UISegmentedControl!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
    let testImageArray = [UIImage(named:"firstFloor"),UIImage(named:"secondFloor"),UIImage(named:"thirdFloor")]
    
    var testEventArray = [Event]()
    var floorOneEvents = [Event]()
    var floorTwoEvents = [Event]()
    var floorThreeEvents = [Event]()
    
    var refreshControl: UIRefreshControl!
    let dateFormatter = DateFormatter()
    
    var mapToggler = MapToggle.Map
    let mapCenter = CLLocationCoordinate2D(latitude: 38.946047, longitude: -92.330131)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Setup
        
        setUpNavBar()
         mapImageView.superview?.bringSubview(toFront: mapImageView)
        mapTableView.dataSource = self
        mapTableView.delegate = self
        dateFormatter.timeStyle = .short
        
        // Loading Schedules
        
        Model.sharedInstance.fakeAPICall()
        loadSchedule()

        // Swipe to Change Level
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    
        // Map Image View
        
        mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
        self.mapScrollView.minimumZoomScale = 1.0
        self.mapScrollView.maximumZoomScale = 8.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        mapScrollView.addGestureRecognizer(tap)
        
        // MapView
        
        mapView.mapType = .hybrid
        mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: true)
    
        // Refresh Control
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        mapTableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: true)
    }
    
// MARK: - Loading Schedules
    
    func loadSchedule() {
        testEventArray = Model.sharedInstance.fullSchedule!
        filterFullScheduleByFloor(fullSchedule: testEventArray)
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
    
    @objc func refresh(_ sender:Any) {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadSchedule()
            self.refreshControl.endRefreshing()
            self.mapTableView.reloadData()
        }
    }
    
// MARK: - Nav Bar Gradient
    
    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
    }
    
//MARK: - Change Map Level
    
    @IBAction func changeLevelOfMap(_ sender: UISegmentedControl) {
        mapScrollView.zoomScale = 1.0
        mapImageView.image = testImageArray[sender.selectedSegmentIndex]
        mapTableView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {return}
        
        switch swipeGesture.direction {
        case .left:
            
            if floorSelector.selectedSegmentIndex != 2 {
                floorSelector.selectedSegmentIndex += 1
                mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                mapTableView.reloadData()
            }

        case .right:
            
            if floorSelector.selectedSegmentIndex != 0 {
                floorSelector.selectedSegmentIndex -= 1
                mapImageView.image = testImageArray[floorSelector.selectedSegmentIndex]
                mapTableView.reloadData()
            }

        default:
            break
        }
    }
    
//MARK: - Map Zoom
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        mapScrollView.setZoomScale(1.0, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }
    
//MARK: - Toggle Map
    
    @IBAction func handleMapToggle(_ sender: Any) {
        switch mapToggler {
        case .Image:
            mapImageView.superview?.bringSubview(toFront: mapImageView)
            mapToggler = .Map
        case .Map:
            mapView.superview?.bringSubview(toFront: mapView)
            mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: false)
            mapToggler = .Image
        }
    }

// MARK: - Tableview
    
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
        
        switch floorSelector.selectedSegmentIndex {
            case 0:
                cell.eventLabel.text = floorOneEvents[indexPath.row].title
                cell.locationLabel.text = floorOneEvents[indexPath.row].location
                cell.timeLabel.text = Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorOneEvents[indexPath.row].time)]! + ", " + dateFormatter.string(from: floorOneEvents[indexPath.row].time)
            case 1:
                cell.eventLabel.text = floorTwoEvents[indexPath.row].title
                cell.locationLabel.text = floorTwoEvents[indexPath.row].location
                cell.timeLabel.text = Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorTwoEvents[indexPath.row].time)]! + ", " + dateFormatter.string(from: floorTwoEvents[indexPath.row].time)
            case 2:
                cell.eventLabel.text = floorThreeEvents[indexPath.row].title
                cell.locationLabel.text = floorThreeEvents[indexPath.row].location
                cell.timeLabel.text = Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorThreeEvents[indexPath.row].time)]! + ", " + dateFormatter.string(from: floorThreeEvents[indexPath.row].time)
            default:
                cell.eventLabel.text = "There is NO Event"
                cell.locationLabel.text = "Who Knows Where"
                cell.timeLabel.text = "No Time"
        }
        
        return cell
    }
    
// MARK: - Segues
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapEventDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EventDetailViewController
        guard let selectedRow = mapTableView.indexPathForSelectedRow else {return}
        
        
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
}

enum MapToggle {
    case Image
    case Map
}

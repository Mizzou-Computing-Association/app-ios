//
//  MapViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit
import MapKit

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {

    @IBOutlet weak var floorSelector: UISegmentedControl!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSuperView: UIView!
    @IBOutlet weak var mapImageSuperView: UIView!
    @IBOutlet weak var centeringButton: UIButton!
    @IBOutlet weak var centeringButtonBackground: UIView!
    
    let testImageArray = [UIImage(named: "firstFloor"), UIImage(named: "secondFloor"), UIImage(named: "thirdFloor")]

    var fullSchedule = [Event]()
    var floorOneEvents = [Event]()
    var floorTwoEvents = [Event]()
    var floorThreeEvents = [Event]()
    var outsideEvents = [Event]()

    var refreshControl: UIRefreshControl!
    let dateFormatter = DateFormatter()

    let mapCenter = CLLocationCoordinate2D(latitude: 38.946047, longitude: -92.330131)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    
    let geologicalPin = MKPointAnnotation()
    let quadPin = MKPointAnnotation()
    let parkingPin = MKPointAnnotation()
    let lafferrePin = MKPointAnnotation()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial Setup

        setUpNavBar()
        mapImageSuperView.superview?.bringSubviewToFront(mapImageSuperView)
        centeringButtonBackground.superview?.bringSubviewToFront(centeringButtonBackground)
        //centeringButton.superview?.bringSubviewToFront(centeringButton)
        centeringButton.tintColor = view.tintColor
        mapTableView.dataSource = self
        mapTableView.delegate = self
        mapView.delegate = self
        dateFormatter.timeStyle = .short

        // Loading Schedules
        loadSchedule()

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
        
        geologicalPin.coordinate = CLLocationCoordinate2D(latitude: 38.947200, longitude: -92.329208)
        quadPin.coordinate = CLLocationCoordinate2D(latitude: 38.946563, longitude: -92.329148)
        parkingPin.coordinate = CLLocationCoordinate2D(latitude: 38.944117, longitude: -92.330883)
        lafferrePin.coordinate = CLLocationCoordinate2D(latitude: 38.946111, longitude: -92.330466)
        
        geologicalPin.title = "Geological Sciences"
        quadPin.title = "The Quad"
        parkingPin.title = "Parking"
        lafferrePin.title = "Lafferre"
        
        mapView.addAnnotations([geologicalPin, parkingPin, quadPin, lafferrePin])
        
        let locationImage = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        centeringButton.setImage(locationImage, for: .normal)
        centeringButtonBackground.layer.cornerRadius = 8
        
        // Refresh Control

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        mapTableView.addSubview(refreshControl)
        locationManager.requestWhenInUseAuthorization()
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
        Model.sharedInstance.scheduleLoad(dispatchQueueForHandler: DispatchQueue.main) {(events, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else if let events = events {
                self.fullSchedule = events
                var tempEvents = [Event]()
                for event in events {
                    let event = Event(time: event.time, location: event.location, floor: event.floor, title: event.title, description: event.description)
                    tempEvents.append(event)
                }
                self.fullSchedule = tempEvents
                self.fullSchedule = Model.sharedInstance.sortEvents(events: self.fullSchedule)!
                self.filterFullScheduleByFloor(fullSchedule: self.fullSchedule)
                self.mapTableView.reloadData()
                
            }
        }
    }

    func filterFullScheduleByFloor(fullSchedule: [Event]) {
        print(fullSchedule)
        var tempFloorOneEvents = [Event]()
        var tempFloorTwoEvents = [Event]()
        var tempFloorThreeEvents = [Event]()
        var tempOutsideEvents = [Event]()

        for event in fullSchedule {
            if event.floor == 0 {
                tempFloorOneEvents.append(event)
            } else if event.floor == 1 {
                tempFloorTwoEvents.append(event)
            } else if event.floor == 2 {
                tempFloorThreeEvents.append(event)
            } else if event.floor == 4 {
                tempOutsideEvents.append(event)
            }
        }
        floorOneEvents = tempFloorOneEvents
        floorTwoEvents = tempFloorTwoEvents
        floorThreeEvents = tempFloorThreeEvents
        outsideEvents = tempOutsideEvents
        mapTableView.reloadData()
    }

    @objc func refresh(_ sender: Any) {
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

// MARK: - Change Map Level

    @IBAction func changeLevelOfMap(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != 3 {
            mapScrollView.superview?.bringSubviewToFront(mapScrollView)
            mapImageView.image = testImageArray[sender.selectedSegmentIndex]
            mapTableView.reloadData()
        } else {
            mapScrollView.setZoomScale(1.0, animated: true)
            mapSuperView.superview?.bringSubviewToFront(mapSuperView)
            mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: false)
            mapTableView.reloadData()
        }
        
    }

// MARK: - Map Zoom

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        mapScrollView.setZoomScale(1.0, animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }
    @IBAction func centerOnLafferre(_ sender: Any) {
        mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: true)
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
        case 3:
            return outsideEvents.count
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
                cell.timeLabel.text =
                    Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorOneEvents[indexPath.row].time)]!
                    + ", " + dateFormatter.string(from: floorOneEvents[indexPath.row].time)
        case 1:
                cell.eventLabel.text = floorTwoEvents[indexPath.row].title
                cell.locationLabel.text = floorTwoEvents[indexPath.row].location
                cell.timeLabel.text =
                    Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorTwoEvents[indexPath.row].time)]!
                    + ", " + dateFormatter.string(from: floorTwoEvents[indexPath.row].time)
        case 2:
                cell.eventLabel.text = floorThreeEvents[indexPath.row].title
                cell.locationLabel.text = floorThreeEvents[indexPath.row].location
                cell.timeLabel.text =
                    Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: floorThreeEvents[indexPath.row].time)]!
                    + ", " + dateFormatter.string(from: floorThreeEvents[indexPath.row].time)
        case 3:
            cell.eventLabel.text = outsideEvents[indexPath.row].title
            cell.locationLabel.text = outsideEvents[indexPath.row].location
            cell.timeLabel.text =
                Model.sharedInstance.weekdayDict[Calendar.current.component(.weekday, from: outsideEvents[indexPath.row].time)]!
                + ", " + dateFormatter.string(from: outsideEvents[indexPath.row].time)
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
        case 3:
            destination.titleText = outsideEvents[selectedRow.row].title
            destination.locationText = outsideEvents[selectedRow.row].location
            destination.timeText = dateFormatter.string(from: outsideEvents[selectedRow.row].time)
            destination.descriptionText = outsideEvents[selectedRow.row].description
        default:
            destination.titleText = "There is NO Event"
            destination.locationText = "Who Knows Where"
            destination.timeText = "No Time"
            destination.descriptionText = "No Description"
        }

    }
}

//
//  EventDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var titleText = "No Title"
    var locationText = "No Location"
    var timeText = "No Time"
    var descriptionText = "No Description"
    
    let mapCenter = CLLocationCoordinate2D(latitude: 38.946047, longitude: -92.330131)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
    let locationManager = CLLocationManager()
    let pin = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Label Initializing
        if titleText != "" && titleText != " " {
            titleLabel.text = titleText
        } else {
            titleLabel.text = "No Title"
        }
        
        if locationText != ""  && locationText != " " {
            locationLabel.text = locationText
        } else {
            mapView.isHidden = true
            locationLabel.text = "No Location"
        }
        
        if descriptionText != "" && descriptionText != " " {
            descriptionLabel.text = descriptionText
        } else {
            descriptionLabel.text = "No Description"
        }
        
        timeLabel.text = timeText
        //Subview Corner Curving
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        // MapView
        mapView.mapType = .hybrid
        
        mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: true)
        
        pin.coordinate = CLLocationCoordinate2D(latitude: 38.946111, longitude: -92.330466)
        
        pin.title = titleText
        
        mapView.addAnnotation(pin)
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension EventDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}


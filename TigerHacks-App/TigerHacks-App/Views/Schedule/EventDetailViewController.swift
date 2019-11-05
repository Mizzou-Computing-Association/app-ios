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
	@IBOutlet weak var checkinButton: UIBarButtonItem!

//    var titleText = "No Title"
//    var locationText = "No Location"
//    var timeText = "No Time"
//    var descriptionText = "No Description"
    var coordinates: CLLocationCoordinate2D?//(latitude: 38.946111, longitude: -92.330466)
	var event: Event?
    
    let mapCenter = CLLocationCoordinate2D(latitude: 38.946047, longitude: -92.330131)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.0013, longitudeDelta: 0.0013)
    
    let locationManager = CLLocationManager()
    let pin = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let event = event else {
			navigationController?.popViewController(animated: false)
			return
    } 
        
    requestLocationPerms()

		titleLabel.text = event.title
		locationLabel.text = event.location ?? ""
		mapView.isHidden = event.location == nil
		descriptionLabel.text = event.description ?? ""
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.dateStyle = .short
		timeLabel.text = formatter.string(from: event.time)

        //Subview Corner Curving
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        // MapView
        mapView.mapType = .hybrid
        
        mapView.setRegion(MKCoordinateRegion(center: mapCenter, span: mapSpan), animated: true)
        
        if let coordinates = coordinates {
            pin.coordinate = coordinates
        } else {
            pin.coordinate = CLLocationCoordinate2D(latitude: 38.946111, longitude: -92.330466)
        }
		pin.title = event.title
        
        mapView.addAnnotation(pin)
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

		Model.sharedInstance.getProfile { profile in
			if let profile = profile {
				self.checkinButton.tintColor = profile.admin ? .systemOrange : .clear
				self.checkinButton.isEnabled = profile.admin
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? CheckinViewController {
        destination.event = event
      }
    }
    
    func requestLocationPerms() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings if you change your mind", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

}



extension EventDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

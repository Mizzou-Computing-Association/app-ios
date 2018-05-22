//
//  EventDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionSubview: UIView!
    
    var titleText = "No Title"
    var locationText = "No Location"
    var timeText = "No Time"
    var descriptionText = "No Description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Label Initializing
//        titleLabel.text = titleText
        navigationItem.title = titleText
        locationLabel.text = locationText
        timeLabel.text = timeText
        descriptionLabel.text = descriptionText
        
        //Subview Corner Curving
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

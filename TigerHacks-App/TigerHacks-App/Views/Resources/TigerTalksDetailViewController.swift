//
//  TigerTalksDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import WebKit


class TigerTalksDetailViewController: UIViewController {

    
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var videoCode: String?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Video Setup
        
        getVideo(videoCode: videoCode ?? "")
        
        // Description Setup
        
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        descriptionLabel.text = descriptionText ?? "No Description"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - Load Video
    
    func getVideo(videoCode: String) {
        if let url = URL(string: "https://www.youtube.com/embed/\(videoCode)") {
            
            // Create the indicator
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            
            // Position in center and start animating
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: videoWebView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: videoWebView.centerYAnchor)])
            activityIndicator.startAnimating()
            
            // Load video
            videoWebView.load(URLRequest(url: url))
            
            // Stop the animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                activityIndicator.stopAnimating()
            }
        }
    }

}

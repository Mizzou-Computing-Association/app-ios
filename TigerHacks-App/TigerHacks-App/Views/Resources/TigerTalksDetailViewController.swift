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
            videoWebView.load(URLRequest(url: url))
        }
    }

}

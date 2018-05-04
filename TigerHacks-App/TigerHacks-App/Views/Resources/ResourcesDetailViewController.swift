//
//  TigerTalksDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import WebKit


class ResourcesDetailViewController: UIViewController {

    
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let testVideoCode = "RmHqOSrkZnk"
    var videoCode: String?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo(videoCode: videoCode ?? "")
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        descriptionLabel.text = descriptionText ?? "No Description"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getVideo(videoCode: String) {
        
        //let urlString = "https://www.youtube.com/embed/\(videoCode)"
        //https://www.youtube.com/embed/RmHqOSrkZnk
        
        if let url = URL(string: "https://www.youtube.com/embed/\(videoCode)") {
            videoWebView.load(URLRequest(url: url))
        }
    
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

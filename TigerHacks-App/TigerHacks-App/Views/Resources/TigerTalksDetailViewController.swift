//
//  TigerTalksDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import WebKit


class TigerTalksDetailViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var videoCode: String?
    var descriptionText: String?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Video Setup
        
        getVideo(videoCode: videoCode ?? "")
        self.videoWebView.navigationDelegate = self
        
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
            
            view.addSubview(activityIndicator)
            
            // Position activity indicator in center
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: videoWebView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: videoWebView.centerYAnchor)])
            
            // Load video
            
            videoWebView.load(URLRequest(url: url))
        }
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}

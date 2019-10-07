//
//  ResourceDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 10/3/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import WebKit

class ResourceDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var resourceWebView: WKWebView!
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resourceWebView.navigationDelegate = self
        loadResource()
        // Do any additional setup after loading the view.
    }
    
    func loadResource() {
        guard let url = URL(string: urlString) else {return}

        // Create the indicator

        view.addSubview(activityIndicator)

        // Position activity indicator in center

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: resourceWebView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resourceWebView.centerYAnchor)])

        // Load Content
//        if navigationItem.title == "Instagram" {
//            print("It's Instagram")
//            if let url = URL(string: "instagram://user?username=tigerhacks") {
//                print("The url worked")
//                if UIApplication.shared.canOpenURL(url) {
//                    print("Can open URL")
//                    if #available(iOS 10.0, *) {
//                        print("is available")
//                        UIApplication.shared.open(url)
//                    } else {
//                        UIApplication.shared.openURL(url)
//                    }
//                } else {
//                    resourceWebView.load(URLRequest(url: url))
//                }
//            }
//        } else if navigationItem.title == "Twitter" {
//            if UIApplication.shared.canOpenURL(url) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            } else {
//                resourceWebView.load(URLRequest(url: url))
//            }
//        } else if navigationItem.title == "Facebook" {
//            if UIApplication.shared.canOpenURL(url) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            } else {
//                resourceWebView.load(URLRequest(url: url))
//            }
//        } else {
//            resourceWebView.load(URLRequest(url: url))
//        }
    
        resourceWebView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
        
    }
}

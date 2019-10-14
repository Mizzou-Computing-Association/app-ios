//
//  ResourceDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 10/3/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import WebKit

class ResourceDetailViewController: UIViewController {

    @IBOutlet weak var resourceWebView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var estimatedProgressObserver: NSKeyValueObservation?
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resourceWebView.navigationDelegate = self
        progressView.isHidden = true
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
    
    func setupEstimatedProgressObserver() {
        estimatedProgressObserver = resourceWebView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
        
    }
}

extension ResourceDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        UIView.transition(with: progressView,
                          duration: 0.33,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.progressView.isHidden = false
        },
                          completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        UIView.transition(with: progressView,
                          duration: 0.33,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.progressView.isHidden = true
        },
                          completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        UIView.transition(with: progressView,
                          duration: 0.33,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.progressView.isHidden = true
        },
                          completion: nil)
    }
}

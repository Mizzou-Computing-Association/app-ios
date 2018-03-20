//
//  SponsorsDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import SafariServices

class SponsorsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate{
    

    @IBOutlet weak var sponsorImage: UIImageView!
    @IBOutlet weak var sponsorTitle: UILabel!
    @IBOutlet weak var sponsorLocation: UILabel!
    @IBOutlet weak var sponsorWebsite: UIButton!
    @IBOutlet weak var sponsorDescription: UILabel!
    @IBOutlet weak var mentorTableView: UITableView!
    @IBOutlet weak var imageViewBorder: UIView!
    @IBOutlet weak var descriptionSubview: UIView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var image:UIImage?
    var titleText:String?
    var locationText:String?
    var websiteText:String?
    var descriptionText:String?
    var mentorList: [Mentor]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        descriptionSubview.clipsToBounds = true
        descriptionSubview.layer.cornerRadius = 20
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        imageViewBorder.clipsToBounds = true
        imageViewBorder.layer.cornerRadius = 10
        imageViewBorder.layer.borderWidth = 1
        imageViewBorder.layer.borderColor = UIColor.lightGray.cgColor
        
        sponsorImage.image = image ?? UIImage(named:"noImage")
        sponsorTitle.text = "\(titleText ?? "There is no name")"
        sponsorLocation.text = "\(locationText ?? "There is no location")"
        sponsorWebsite.setTitle(websiteText, for: .normal)
        sponsorWebsite.setTitle("There is no website", for: .disabled)
        if URL.init(string: websiteText ?? "uh oh") != nil {
            sponsorWebsite.isEnabled = true
        }else {
            sponsorWebsite.isEnabled = false
            
        }
        
        sponsorDescription.text = "\(descriptionText ?? "There is no description")"

        
        //navItem.title = image?.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let mentorList = mentorList {
            return mentorList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentorCell", for: indexPath) as! MentorTableViewCell
        
        
        if let mentor = mentorList?[indexPath.row] {
            cell.textLabel?.text = mentor.name
            cell.detailTextLabel?.text = mentor.skills?.first
        }
        
        return cell
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func openURL(_ sender: UIButton) {
        guard var urlString = sender.titleLabel?.text else { return }

        urlString = "https://www.\(urlString)"
        
        
        if let url = URL(string: urlString) {
            
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)

        }

        

    }
//  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//
//        if navigationType == UIWebViewNavigationType.linkClicked {
//            UIApplication.shared.open(<#T##url: URL##URL#>, options: <#T##[String : Any]#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//            return false
//        }
//
//        return true
//    }
    
    
}

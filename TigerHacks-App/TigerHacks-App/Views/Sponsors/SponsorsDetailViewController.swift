//
//  SponsorsDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit
import SafariServices

class SponsorsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, MentorCellDelegate{
    

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
    
    var refreshControl: UIRefreshControl!
    
    let baseSlackHooks = "slack://user?team=T89F9GPRR&id="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMentors()
        
        // Label Initialization
        
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

        // Refresh Control
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        mentorTableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - Load Mentor Data
    
    func loadMentors() {
        if let titleText = titleText {
            mentorList = Model.sharedInstance.sponsors?.first(where: {$0.name == titleText})?.mentors
        }
    }
    
    @objc func refresh(_ sender:Any) {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadMentors()
            self.refreshControl.endRefreshing()
            self.mentorTableView.reloadData()
        }
    }
    
    func parseMentorSkills(skills: [String]) -> String {
        var skillsCommaSeparated = ""
        for skill in skills {
            if skillsCommaSeparated.isEmpty {
                skillsCommaSeparated = " " + skillsCommaSeparated + skill
            }else {
                skillsCommaSeparated = skillsCommaSeparated + ", " + skill
            }
        }
        return skillsCommaSeparated
    }
    
// MARK: - Open Contact URL
    
    func mentorTableViewCellDidTapContact(_ sender: MentorTableViewCell) {
        guard let tappedIndexPath = mentorTableView.indexPath(for: sender),
        let backupUrl = URL(string: "https://slack.com/downloads/ios"),
        let mentorList = self.mentorList,
        let mentorContact = mentorList[tappedIndexPath.row].contact else { return }
        
        let slackHooks = baseSlackHooks + mentorContact
        let slackURL = URL(string: slackHooks)
        
        if UIApplication.shared.canOpenURL(slackURL!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(slackURL!)
            } else {
                UIApplication.shared.openURL(slackURL!)
            }
        }else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(backupUrl)
            } else {
                UIApplication.shared.openURL(backupUrl)
            }
        }
        
        //Open Slack with contact url: slack://user?team={TEAM_ID}&id={USER_ID}
        //TEAM_ID = workspace id
        //USER_ID = users id
        //Will open a direct message if possible, otherwise will take you to a download link for slack
    }
    
// MARK: - Open Sponsor URL
    
    @IBAction func openSponsorURL(_ sender: UIButton) {
        guard let baseUrlString = sender.titleLabel?.text else { return }
        
        let fullUrlString = "https://www.\(baseUrlString)"
        
        if let url = URL(string: fullUrlString) {
            let webviewConfig = SFSafariViewController.Configuration()
            webviewConfig.entersReaderIfAvailable = true
            
            let webview = SFSafariViewController(url: url, configuration: webviewConfig)
            present(webview, animated: true)
        }
    }
    
// MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mentorList = mentorList {
            return mentorList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentorCell", for: indexPath) as! MentorTableViewCell
        cell.delegate = self
        
        if let mentor = mentorList?[indexPath.row] {
            cell.mentorNameLabel?.text = mentor.name
            if let skills = mentor.skills {
                cell.mentorSkillsLabel?.text = parseMentorSkills(skills: skills)
            }else {
                cell.mentorSkillsLabel?.text = "No skills!"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  AllMentorTableViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 8/28/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class AllMentorTableViewController: UITableViewController, MentorCellDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    let baseSlackHooks = "slack://user?team=T89F9GPRR&id="
    var mentorList = [Mentor]()
    var filteredMentors = [Mentor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find a Mentor"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar

    }

    func parseMentorSkills(skills: [String]) -> String {
        var skillsCommaSeparated = ""
        for skill in skills {
            if skillsCommaSeparated.isEmpty {
                skillsCommaSeparated = " " + skillsCommaSeparated + skill
            } else {
                skillsCommaSeparated += ", " + skill
            }
        }
        return skillsCommaSeparated
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mentorTableViewCellDidTapContact(_ sender: MentorTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender),
            let backupUrl = URL(string: "https://slack.com/downloads/ios") else { return }

        var mentorContact = ""
        if isFiltering() {
            guard let contact = filteredMentors[tappedIndexPath.row].contact else { return }
            mentorContact = contact
        } else {
            guard let contact = mentorList[tappedIndexPath.row].contact else { return }
            mentorContact = contact
        }

        let slackHooks = baseSlackHooks + mentorContact
        let slackURL = URL(string: slackHooks)

        if UIApplication.shared.canOpenURL(slackURL!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(slackURL!)
            } else {
                UIApplication.shared.openURL(slackURL!)
            }
        } else {
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

    func filterMentorsforSearchText(_ searchText: String, scope: String = "All") {
            filteredMentors = mentorList.filter({(mentor: Mentor) -> Bool in
                if mentor.name.lowercased().contains(searchText.lowercased()) {
                    return true
                } else {
                    if let skills = mentor.skills {
                        for skill in skills {
                            if skill.lowercased().contains(searchText.lowercased()) {
                                return true
                            }
                        }
                    }
                }
                return false
            })
        tableView.reloadData()

    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterMentorsforSearchText(searchController.searchBar.text!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMentors.count
        } else {
            return mentorList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allMentorCell", for: indexPath) as! MentorTableViewCell
        cell.delegate = self

        if isFiltering() {
            cell.mentorNameLabel.text = filteredMentors[indexPath.row].name
            if let skills = filteredMentors[indexPath.row].skills {
                cell.mentorSkillsLabel.text = parseMentorSkills(skills: skills)
            } else {
                cell.mentorSkillsLabel.text = ""
            }
        } else {
            cell.mentorNameLabel.text = mentorList[indexPath.row].name
            if let skills = mentorList[indexPath.row].skills {
                cell.mentorSkillsLabel.text = parseMentorSkills(skills: skills)
            } else {
                cell.mentorSkillsLabel.text = ""
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  SponsorsCollectionViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

private let reuseIdentifier = "sponsorCell"

class SponsorsCollectionViewController: UICollectionViewController {

    var sponsors = [Sponsor]()
    var allMentors = [Mentor]()
    var refreshControl: UIRefreshControl!
    
    let levelDict: [Int: String] = [0: "Platinum", 1: "Gold", 2: "Silver", 3: "Bronze"]
    var platinumSponsors = [Sponsor]()
    var goldSponsors = [Sponsor]()
    var silverSponsors = [Sponsor]()
    var bronzeSponsors = [Sponsor]()

    var platinumTotal = 0
    var goldTotal = 0
    var silverTotal = 0
    var bronzeTotal = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial Setup

        Model.sharedInstance.fakeAPICall()
        loadSponsors(dispatchQueueForHandler: DispatchQueue.main) {_, _ in
            //Do nothing as far as I can tell
        }

        // Collection View Setup

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {

            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset.left = 10
            flowLayout.sectionInset.right = 10
//            let horizontalSpacing = flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.right*2
            let cellWidth = (view.frame.width)// - (numberOfCells-1)*horizontalSpacing)/numberOfCells
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth/2)
            
        }

        // Refresh Control

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        collectionView?.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// MARK: - Load Sponsors

    @objc func refresh(_ sender: Any) {
        self.loadSponsors(dispatchQueueForHandler: DispatchQueue.main) {(sponsors, _) in
            self.sponsors.removeAll()
            if let sponsors = sponsors {
                self.sponsors = sponsors
            }
            self.refreshControl.endRefreshing()
        }
        
//      self.collectionView?.reloadData()
        
    }

    func loadSponsors(dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Sponsor]?, String?) -> Void) {
        Model.sharedInstance.sponsorsLoad(dispatchQueueForHandler: DispatchQueue.main) { (sponsors, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                completionHandler(nil, "Error loading Sponsors")
            } else if let sponsors = sponsors {
                self.sponsors = sponsors
                self.collectionView?.reloadData()
                self.sponsors.append(Sponsor(
                    mentors: nil,
                    name: "All Mentors",
                    description: nil,
                    website: nil,
                    image: UIImage(named: "tigerLogo-allMentors"),
                    imageUrl: nil,
                    level: 3))
                self.countSponsors()
                self.sortSponsors()
                self.getAllMentors()
                completionHandler(sponsors, nil)

            }
        }
    }
    
    func countSponsors() {
        for sponsor in sponsors {
            switch sponsor.level {
            case 0:
                platinumSponsors.append(sponsor)
            case 1:
                goldSponsors.append(sponsor)
            case 2:
                silverSponsors.append(sponsor)
            case 3:
                bronzeSponsors.append(sponsor)
            default:
                bronzeSponsors.append(sponsor)
            }
        }
    }
    
    func sortSponsors() {
        sponsors = sponsors.sorted(by: { $0.level < $1.level })
    }

    func getAllMentors() {
        allMentors.removeAll()
        for sponsor in sponsors {
            if let mentors = sponsor.mentors {
                for mentor in mentors {
                    allMentors.append(mentor)
                }
            }

        }
        print("All Mentors: \(allMentors)")
    }

// MARK: - Collection View

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SponsorHeader {
            sectionHeader.headerTitle.text = levelDict[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return platinumSponsors.count
        case 1:
            return goldSponsors.count
        case 2:
            return silverSponsors.count
        case 3:
            return bronzeSponsors.count
        default:
            return bronzeSponsors.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SponsorCollectionViewCell
        var sponsor: Sponsor?
        switch indexPath.section {
        case 0:
            sponsor = platinumSponsors[indexPath.row]
        case 1:
            sponsor = goldSponsors[indexPath.row]
        case 2:
            sponsor = silverSponsors[indexPath.row]
        case 3:
            sponsor = bronzeSponsors[indexPath.row]
        default:
            sponsor = bronzeSponsors[indexPath.row]
        }
       
        cell.view.clipsToBounds = true
        cell.view.layer.cornerRadius = 20
        cell.view.layer.borderWidth = 0.5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.view.layer.cornerRadius).cgPath

        cell.view.layer.borderColor = UIColor.lightGray.cgColor
        if let sponsor = sponsor {
            if let image = sponsor.image {
                cell.sponsorImage?.image = image
            } else if let imageUrl = sponsor.imageUrl,
                !imageUrl.isEmpty {
                Model.sharedInstance.dowloadImage(imageString: imageUrl, dispatchQueueForHandler: DispatchQueue.main) { (finalImage, errorString) in
                    if let error = errorString {
                        print("ERROR! could not download image: \(error.localizedLowercase)")
                    } else if let image = finalImage {
                        switch indexPath.section {
                        case 0:
                            self.platinumSponsors[indexPath.row].image = image
                        case 1:
                            self.goldSponsors[indexPath.row].image = image
                        case 2:
                            self.silverSponsors[indexPath.row].image = image
                        case 3:
                            self.bronzeSponsors[indexPath.row].image = image
                        default:
                            self.bronzeSponsors[indexPath.row].image = image
                        }
                        collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
        
        return cell
    }

// MARK: - Segues

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0, 1, 2:
            performSegue(withIdentifier: "sponsorSegue", sender: self)
        case 3:
            if bronzeSponsors[indexPath.row].name == "All Mentors" {
                performSegue(withIdentifier: "mentorSegue", sender: self)
            } else {
              performSegue(withIdentifier: "sponsorSegue", sender: self)
            }
        default:
            performSegue(withIdentifier: "sponsorSegue", sender: self)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var sponsor: Sponsor?
        
        if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
            switch indexPath.section {
            case 0:
                sponsor = platinumSponsors[indexPath.row]
            case 1:
                sponsor = goldSponsors[indexPath.row]
            case 2:
                sponsor = silverSponsors[indexPath.row]
            case 3:
                sponsor = bronzeSponsors[indexPath.row]
            default:
                sponsor = bronzeSponsors[indexPath.row]
            }
            
            if segue.identifier == "sponsorSegue" {
                let destination = segue.destination as! SponsorsDetailViewController

                if let sponsor = sponsor {
                    if let image = sponsor.image {
                        destination.image = image
                    } else {
                        destination.image = UIImage(named: "noImage")
                    }

                    destination.titleText = sponsor.name
                    destination.websiteText = sponsor.website
                    destination.descriptionText = sponsor.description
                    if let mentorList = sponsor.mentors {
                        destination.mentorList = mentorList
                    }

                }
            } else {

                let destination = segue.destination as! AllMentorTableViewController

                self.navigationItem.backBarButtonItem?.title = ""

                destination.mentorList = allMentors
            }
        }
        
    }
}

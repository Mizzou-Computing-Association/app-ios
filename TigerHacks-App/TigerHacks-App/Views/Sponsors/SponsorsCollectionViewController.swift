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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial Setup

        setUpNavBar()
        Model.sharedInstance.fakeAPICall()
        loadSponsors()

        // Collection View Setup

        let numberOfCells = CGFloat(2)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {

            flowLayout.minimumInteritemSpacing = 20
            flowLayout.minimumLineSpacing = 20
            flowLayout.sectionInset.left = 20
            flowLayout.sectionInset.right = 20
            let horizontalSpacing = flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.right*2
            let cellWidth = (view.frame.width - (numberOfCells-1)*horizontalSpacing)/numberOfCells
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            
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
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadSponsors()
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }

    func loadSponsors() {
        Model.sharedInstance.sponsorsLoad(dispatchQueueForHandler: DispatchQueue.main) { (sponsors, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
                
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                    self.present(alert, animated: true)
                
            } else if let sponsors = sponsors {
                self.sponsors = sponsors
                self.collectionView?.reloadData()
            }
        }
        
        sponsors.append(Sponsor(
            mentors: nil,
            name: "All Mentors",
            description: nil,
            website: nil,
            location: nil,
            image: UIImage(named: "tigerLogo-allMentors") ,
            imageUrl: nil,
            level: nil))
        getAllMentors()
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
    }

// MARK: - Nav Bar Gradient

    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
    }

// MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SponsorCollectionViewCell

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
        if let image = sponsors[indexPath.row].image {
            cell.sponsorImage?.image = image
        } else if let imageUrl = sponsors[indexPath.row].imageUrl,
            !imageUrl.isEmpty {
            Model.sharedInstance.dowloadImage(imageString: imageUrl, dispatchQueueForHandler: DispatchQueue.main) { (finalImage, errorString) in
                if let error = errorString {
                    print("ERROR! could not download image")
                } else if let image = finalImage {
                    self.sponsors[indexPath.row].image = image
                    collectionView.reloadData()
                }
            }
        }

        return cell
    }

// MARK: - Segues

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if sponsors[indexPath.row].name == "All Mentors" {
            performSegue(withIdentifier: "mentorSegue", sender: self)
        } else {
            performSegue(withIdentifier: "sponsorSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "sponsorSegue" {
            let destination = segue.destination as! SponsorsDetailViewController
            let selectedItem = collectionView?.indexPathsForSelectedItems?.first

            if let row = selectedItem?.row {
                let sponsor = sponsors[row]
                if let image = sponsor.image {
                    destination.image = image
                } else {
                    destination.image = UIImage(named: "noImage")
                }

                destination.titleText = sponsor.name
                destination.locationText = sponsor.location
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

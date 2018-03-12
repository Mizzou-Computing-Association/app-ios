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

    let testArray = [UIImage(named:"linkedInPhoto"),UIImage(named:"sherduck"),UIImage(named:"waterPoloBall")]
    
    let testSponsorArray = [Sponsor(mentors: nil,
                                    name: "AirBnb",
                                    description: "we find homes that you can rent. Undercut the hotels",
                                    website: "airbnb.com",
                                    location: "Table 5, Main Hallway",
                                    image: UIImage(named:"airbnb")),
                            Sponsor(mentors: nil,
                                    name: "Cerner",
                                    description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",
                                    website: "Cerner.com",
                                    location: "Table 6, Main Hallway",
                                    image: UIImage(named:"cerner")),
                            Sponsor(mentors: nil,
                                    name: "Google",
                                    description: "we google stuff all day",
                                    website: "google.com",
                                    location: "Table 7, Main Hallway",
                                    image: UIImage(named:"google")),
                            Sponsor(mentors: nil,
                                    name: "Pied Piper",
                                    description: "Compression software haha relevant topical joke software",
                                    website: "There is no website",
                                    location: "Table 8, Main Hallway",
                                    image: UIImage(named:"piedpiper")),
                            Sponsor(mentors: nil,
                                    name: "Microsoft",
                                    description: "we bing stuff all day",
                                    website: "bing.com",
                                    location: "Table 9, Main Hallway",
                                    image: UIImage(named:"microsoft")),
                            Sponsor(mentors: nil,
                                    name: "FulcrumGT",
                                    description: nil,
                                    website: nil,
                                    location: nil,
                                    image: nil),
                            Sponsor(mentors: nil,
                                    name: "Fulcrum GT",
                                    description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                    website: "dogfood.org",
                                    location: "Table 10, Main Hallway",
                                    image: UIImage(named:"fulcrumgt")),
                            Sponsor(mentors: nil,
                                    name: "Fulcrum GT",
                                    description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                    website: "dogfood.org",
                                    location: "Table 10, Main Hallway",
                                    image: UIImage(named:"fulcrumgt")),
                            Sponsor(mentors: nil,
                                    name: "Fulcrum GT",
                                    description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                    website: "dogfood.org",
                                    location: "Table 10, Main Hallway",
                                    image: UIImage(named:"fulcrumgt")),
                            Sponsor(mentors: nil,
                                    name: "Fulcrum GT",
                                    description: "DOGFOOD GOES TO THE MARKET, YOU WALKED IT THERE, YOU'RE KILLIN IT YOU YOUNG ENTREPRENEUR. NOBODY HAS A .ORG NOT EVEN US",
                                    website: "dogfood.org",
                                    location: "Table 10, Main Hallway",
                                    image: UIImage(named:"fulcrumgt"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.collectionView!.register(SponsorCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let numberOfCells = CGFloat(2)
        
        
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            flowLayout.minimumInteritemSpacing = 2
            flowLayout.minimumLineSpacing = 2
            
            let horizontalSpacing = flowLayout.minimumInteritemSpacing
            
            let cellWidth = (view.frame.width - (numberOfCells-1)*horizontalSpacing)/numberOfCells
            
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return testSponsorArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SponsorCollectionViewCell
        
        cell.view.clipsToBounds = true
        cell.view.layer.cornerRadius = 20
        cell.view.layer.borderWidth = 0.5
        cell.view.layer.borderColor = UIColor.lightGray.cgColor
        
        
        if let image = testSponsorArray[indexPath.row].image {
            cell.sponsorImage?.image = image
        }else {
            cell.sponsorImage?.image = UIImage(named:"noImage")
        }
        
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "sponsorSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SponsorsDetailViewController
        let selectedItem = collectionView?.indexPathsForSelectedItems?.first
        
        if let row = selectedItem?.row {
            let sponsor = testSponsorArray[row]
            
            if let image = sponsor.image {
                destination.image = image
            }else {
                destination.image = UIImage(named:"noImage")
            }
            
            destination.titleText = sponsor.name
            destination.locationText = sponsor.location
            destination.websiteText = sponsor.website
            destination.descriptionText = sponsor.description
            destination.mentorList = nil
            
            
        }
        
        
        
    }
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

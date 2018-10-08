//
//  PrizeDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class PrizeDetailViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sponsorSubview: UIView!
    @IBOutlet weak var rewardSubview: UIView!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeSubview: UIView!

    var sponsor: Sponsor?
    var titleText: String?
    var rewardText: String?
    var descriptionText: String?
    var typeText: String?

    var testBeginnerPrizes = [Prize]()
    var testMainPrizes = [Prize]()
    var favoriteBeginnerPrizes = [Prize]()
    var favoriteMainPrizes = [Prize]()
    
    var favorited = false
    let favoriteIconImage = UIImage(named: "favorite")
    let favoriteSelectedIconImage = UIImage(named: "favorite_selected")
    var favoriteButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Data

        Model.sharedInstance.fakeAPICall()
//        testBeginnerPrizes = Model.sharedInstance.beginnerPrizes!
//        testMainPrizes = Model.sharedInstance.mainPrizes!

        // Styling for Subviews

        self.view.bringSubviewToFront(rewardLabel)
        sponsorSubview.clipsToBounds = true
        rewardSubview.clipsToBounds = true
        descriptionSubview.clipsToBounds = true
        typeSubview.clipsToBounds = true

        sponsorSubview.layer.cornerRadius = 20
        rewardSubview.layer.cornerRadius = 20
        descriptionSubview.layer.cornerRadius = 20
        typeSubview.layer.cornerRadius = 20

        sponsorSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        rewardSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        typeSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]

        // Set Label Text

        navigationItem.title = titleText
        sponsorLabel.text = "\(sponsor?.name ?? "This isn't a sponsored prize")"
        rewardLabel.text = "\(rewardText ?? "There is no reward. Personally I wouldn't try for this prize...")"
        descriptionLabel.text = "\(descriptionText ?? "There is no description. Weird, somebody probably should've provided a description")"
        typeLabel.text = "\(typeText ?? "There is no type")"
        
        // Favorites
        
        setupFavoriteBarButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        let mainPrizeTest = favoriteMainPrizes.filter { $0.title == titleText }
        let beginnerPrizeTest = favoriteBeginnerPrizes.filter { $0.title == titleText }

        if mainPrizeTest.count != 0 || beginnerPrizeTest.count != 0 {
            favorited = true
        } else {
            favorited = false
        }

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Favorites
    
    @IBAction func favorite(_ sender: UIBarButtonItem) {
        // Currently only cosmetic. Still need to actually add, save, and present favorites.
        toggleFavorited()
        
        let prize = testBeginnerPrizes.filter { $0.title == titleText }
        for prize in prize {
            favoriteBeginnerPrizes.append(prize)
        }
        
    }
    
    // MARK: - Favorites
    
    @objc func tappedFavoriteButton() {
        toggleFavorited()
    }
    
    // MARK: - Favorite Button Animation 
    
    func setupFavoriteBarButtonItem() {
        guard let size = favoriteIconImage?.size else {
            return
        }
        
        let favoriteIconRect = CGRect(origin: CGPoint.zero, size: size)
        favoriteButton = UIButton(frame: favoriteIconRect)
        favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)
        favoriteButton?.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchUpInside)
        if let favoriteButton = favoriteButton {
            favoriteBarButtonItem.customView = favoriteButton
        }
    }
    
    func toggleFavorited(){
        if favorited {
            favorited = false
            favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)
        } else {
            favorited = true
        favoriteButton?.setBackgroundImage(favoriteSelectedIconImage, for: .normal)
        }
        favoriteButton?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.favoriteButton?.transform = CGAffineTransform.identity
        }, completion: { (_) in
            print("favorite was tapped and the animation happened")
        })
    }
}

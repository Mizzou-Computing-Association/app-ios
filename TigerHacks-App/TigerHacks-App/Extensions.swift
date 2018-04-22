//
//  Extensions.swift
//  TigerHacks-App
//
//  Created by Evan Teters on 4/19/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func convertGradientToImage(colors: [UIColor], frame: CGRect) -> UIImage {
        
        // start with a CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        // add colors as CGCologRef to a new array and calculate the distances
        var colorsRef = [CGColor]()
        let locations = [0,1]
        
        for i in 0 ... colors.count-1 {
            colorsRef.append(colors[i].cgColor as CGColor)
            //locations.append(Float(i)/Float(colors.count-1))
        }
        
        gradientLayer.colors = colorsRef
        gradientLayer.locations = locations as [NSNumber]?
        
        // now build a UIImage from the gradient
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // return the gradient image
        return gradientImage!
    }
}

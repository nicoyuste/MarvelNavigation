//
//  UIImage+Gradient.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Static method that returns an image with a gradient between colors
    /// - Parameters:
    ///   - bounds: Specify the frame for the new image that is going to be created
    ///   - colors: An array with the colors you want the grandiend on.
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        // This is commented here for now, if you discomment this, the gradient will be vertical instead of horizontal
        //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5);
        //        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

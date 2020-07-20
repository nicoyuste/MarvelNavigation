//
//  UIColor+Inverse.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 19/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Returns the inverse color of the. Imagine your color is white, the inverse will be black.
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black // Return a default colour
    }
}

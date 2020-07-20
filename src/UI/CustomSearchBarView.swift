//
//  CustomSearchBarView.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit


/// Custom View with a textField and clear button. It will be used for the search view on the List View Controller
class CustomSearchBarView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    class func instanceFromNib() -> CustomSearchBarView {
        return UINib(nibName: "CustomSearchBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomSearchBarView
    }
    
    override func layoutSubviews() {
        textField.layer.masksToBounds = true
    }
}

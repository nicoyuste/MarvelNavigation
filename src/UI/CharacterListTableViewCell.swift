//
//  MarvelListTableViewCell.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit

class CharacterListTableViewCell: MarvelListTableViewCell {
    
    override func layoutSubviews() {
        marvelImageView.layer.masksToBounds = false
        marvelImageView.layer.borderColor = UIColor.white.cgColor
        marvelImageView.layer.borderWidth = 2
        marvelImageView.layer.shadowColor = UIColor.white.cgColor
        marvelImageView.layer.shadowOffset = marvelImageView.bounds.size
        marvelImageView.layer.cornerRadius = marvelImageView.frame.height/2
        marvelImageView.clipsToBounds = true
        super.layoutSubviews()
    }
}

//
//  ComicListTableViewCell.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
//
//  MarvelListTableViewCell.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit

class ComicListTableViewCell: MarvelListTableViewCell {
    
    override func layoutSubviews() {
        marvelImageView.layer.masksToBounds = false
        marvelImageView.layer.borderColor = UIColor.white.cgColor
        marvelImageView.layer.borderWidth = 2
        marvelImageView.layer.shadowColor = UIColor.white.cgColor
        marvelImageView.layer.shadowOffset = marvelImageView.bounds.size
        marvelImageView.clipsToBounds = true
        
        titleLabel.textColor = .black
        subtitleLabel.textColor = .black
        
        super.layoutSubviews()
    }
}

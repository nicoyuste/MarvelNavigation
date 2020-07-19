//
//  MarvelListTableViewCell.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit



class MarvelListTableViewCell: UITableViewCell {
    
    static let cellHeights: [String: CGFloat] = [
        "ComicListTableViewCell": 200.0,
        "SeriesListTableViewCell": 120.0,
        "CharacterListTableViewCell": 120.0
    ]
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var marvelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func layoutSubviews() {
        backgroundColor = .clear
        marvelImageView.backgroundColor = .clear
        backgroundImageView.backgroundColor = .clear
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        marvelImageView.image = nil
        backgroundImageView.image = nil
    }
}

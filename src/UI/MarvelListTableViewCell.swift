//
//  MarvelListTableViewCell.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 18/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit


/// Base Table View cell to display Marvel resources
/// If you want to do any specific variation to one of your subclass you can do that. If not, like the Series, you don't need to create the override and use the default configuration.
class MarvelListTableViewCell: UITableViewCell {
    
    // TODO: cellHeights not super clean, we could have just a variable with a default value that gets overriden by each subclass
    
    /// If you create an override cell, you can specify here what is the height for that one.
    /// The ListViewController only knows about MarvelListTableViewCell and it doesn't know about the child cell classes.
    static let cellHeights: [String: CGFloat] = [
        "MarvelListTableViewCell": 50.0,
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

//
//  MarvelDetailsViewController.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 19/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Hero
import SDWebImage


class MarvelDetailsViewController: UIViewController {
    
    private var viewModel: MarvelListViewModel!
    
    // UI
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    internal static func instantiate(with viewModel: MarvelListViewModel) -> MarvelDetailsViewController {
        let ui = UIStoryboard(name: "Main", bundle: nil)
        let vc = ui.instantiateViewController(withIdentifier: "MarvelDetailsViewController") as! MarvelDetailsViewController
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        
        if let imageUrl = viewModel.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "hero_placeholder"))
        } else {
            let placeHolderImage = UIImage(named: "hero_placeholder")
            imageView.image = placeHolderImage
        }
        
        titleLabel.text = viewModel.name
        
        descriptionLabel.text = viewModel.description
    }
    
    // MARK: - Actions
    @objc private func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

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
import SDWebImage


/// Details VIew Controller for the Marvel Resources.
/// This viewController is pretty basic and it is here just to show how transitions in the app would happen.
/// Things which can be improved:
///    - Instead of loading all the information from the MarvelListViewModel, this viewController could use the API to load the DETAIL resource
///    - UI could show more data than only title and description, at the end, you already see that on the list.
class MarvelDetailsViewController: UIViewController {
    
    /// The viewModel holding the information for the view
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

    // MARK: - View Lifecycle
    
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

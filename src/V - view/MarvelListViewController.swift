//
//  MasterViewController.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import JGProgressHUD
import SwiftIcons

/* Things I would like to do on top of this view controller so we have a better user experience.
 *
 *  - Add a loading row at the bottom of the page so it is clear when we are loading more information
*/
class MarvelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    private let HEADER_INSET = CGFloat(300)
    private let HEADER_HEIGHT = CGFloat(60)
    
    private let SEARCH_VIEW_TAG = 12345245
    private var secureStatusBarHeight: CGFloat {
        get {
            return max(view.safeAreaInsets.top, 20)
        }
    }
    
    // UI
    private let tableView: UITableView!
    private let imageView: UIImageView!
    private let searchButton: UIButton!
    private var searchTextField: UITextField?
    private let hud = JGProgressHUD(style: .dark)
    
    // Data
    private let presenter: MarvelPresenter
    private var viewModels: [MarvelListViewModel] = []
        
    // MARK: - Init Methods
    
    init(presenter: MarvelPresenter) {
        self.presenter = presenter
        
        self.imageView = UIImageView(image: UIImage(named: presenter.headerImageName) )
        self.tableView = UITableView()
        self.searchButton = UIButton(type: .custom)
        super.init(nibName: nil, bundle: nil)
        
        imageView.contentMode = .scaleAspectFit
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        imageView.backgroundColor = presenter.backgroundColor
        
        view.backgroundColor = presenter.backgroundColor
        view.addSubview(tableView)
        view.addSubview(imageView)
        view.addSubview(searchButton)
        
        hud.textLabel.text = "Loading..."
        
        searchButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        searchButton.setImage( UIImage.init(icon: .ionicons(.androidSearch), size: CGSize(width: 45, height: 45)).withRenderingMode(.alwaysTemplate), for: .normal)
        searchButton.tintColor = presenter.backgroundColor.inverse()
        searchButton.addTarget(presenter, action: #selector(presenter.userWantsToEnterSearchMode), for: .touchUpInside)
        searchButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalTo(view.snp.topMargin)
            make.right.equalTo(view.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsets(top: secureStatusBarHeight + HEADER_INSET - HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: presenter.tableViewCellToDisplay, bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.frame = CGRect(x: view.safeAreaInsets.left, y: HEADER_HEIGHT, width: view.bounds.size.width, height: view.bounds.size.height - HEADER_HEIGHT)
        imageView.frame = CGRect(x: 0, y: secureStatusBarHeight, width: view.bounds.size.width, height: HEADER_INSET)
        super.viewWillAppear(animated)
    }
    
    // MARK: - UI Notifications received from the presenter
    /// The presenter will call all this methods whenever something needs to be done on the View
    
    private func createAddAndReturnCustomeSearchView() -> CustomSearchBarView {
        let searchView = CustomSearchBarView.instanceFromNib()
        searchView.frame = searchButton.frame
        searchView.backgroundColor = presenter.backgroundColor
        searchView.tag = SEARCH_VIEW_TAG
        searchView.clearButton.addTarget(presenter, action: #selector(presenter.userWantsToCloseSearchMode), for: .touchUpInside)
        searchView.textField.addTarget(self, action: #selector(newQueryToFilter), for: .editingChanged)
        searchTextField = searchView.textField
        view.insertSubview(searchView, belowSubview: searchButton)
        return searchView
    }
    
    func enterSearchMode() {
        let searchView = createAddAndReturnCustomeSearchView()
        UIView.animate(withDuration: 0.2, animations: {
            searchView.frame = CGRect(x: 0, y: self.secureStatusBarHeight, width: self.view.bounds.size.width, height: self.HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsets(top: self.secureStatusBarHeight, left: 0, bottom: 0, right: 0)
            self.searchButton.alpha = 0.0
        }) { (success) in
            self.searchTextField?.becomeFirstResponder()
        }
    }
    
    func closeSearchMode() {
        let searchView = view.viewWithTag(SEARCH_VIEW_TAG)
        UIView.animate(withDuration: 0.2, animations: {
            searchView?.frame = self.searchButton.frame
            self.searchButton.alpha = 1.0
            self.tableView.contentInset = UIEdgeInsets(top: self.secureStatusBarHeight + self.HEADER_INSET - self.HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        }) { (success) in
            searchView?.removeFromSuperview()
        }
    }
    
    func reloadData(viewModels: [MarvelListViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func showLoading() {
        hud.show(in: view)
    }
    
    func removeLoading() {
        hud.dismiss()
    }
    
    // MARK: - Actions
    
    @objc private func newQueryToFilter(textField: UITextField) {
        if let text = textField.text {
            presenter.userEnteredNewQueryInSearchBar(newQuery: text)
        }
    }
    
    // MARK: - ScrollView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField?.resignFirstResponder()
        let y = secureStatusBarHeight + HEADER_INSET - (scrollView.contentOffset.y + HEADER_INSET)
        let height = min(max(y,HEADER_HEIGHT),UIScreen.main.bounds.size.height)
        imageView.frame = CGRect(x: 0, y: secureStatusBarHeight, width: UIScreen.main.bounds.size.width, height: height)
    }

    // MARK: - Table View Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MarvelListTableViewCell.cellHeights[presenter.tableViewCellToDisplay] ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check if we want to load more view Models
        presenter.loadedElementIntoTableView(index: indexPath.row)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MarvelListTableViewCell else { return UITableViewCell() }
        let viewModel = viewModels[indexPath.row]
        cell.titleLabel.text = viewModel.name
        cell.subtitleLabel.text = viewModel.description
        if let imageUrl = viewModel.imageUrl {
            cell.marvelImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "hero_placeholder") ) { (image, error, cacheType, url) in
                if let image = image, let color = image.averageColor {
                    cell.backgroundImageView.image = UIImage.gradientImageWithBounds(bounds: cell.backgroundImageView.bounds, colors: [self.presenter.backgroundColor.cgColor, color.cgColor])
                }
            }
        } else {
            let placeHolderImage = UIImage(named: "hero_placeholder")
            let color = placeHolderImage?.averageColor
            cell.marvelImageView.image = placeHolderImage
            if let color = color {
                cell.backgroundImageView.image = UIImage.gradientImageWithBounds(bounds: cell.backgroundImageView.bounds, colors: [self.presenter.backgroundColor.cgColor, color.cgColor])
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userWantsToEnterDetailsPageForIndex(index: indexPath.row)
    }
}


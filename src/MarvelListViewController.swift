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



class MarvelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let HEADER_INSET = CGFloat(300)
    let HEADER_HEIGHT = CGFloat(60)
    
    let SEARCH_VIEW_TAG = 12345245
    var secureStatusBarHeight: CGFloat {
        get {
            return max(view.safeAreaInsets.top, 20)
        }
    }
    
    /* Things I would like to do on top of this view controller so we have a better user experience.
     *
     *  - Add a loading row at the bottom of the page so it is clear when we are loading more information
     *  - We could store the initial set of objects so we don't have to refresh it after stop the search
    */
    
    // UI
    let tableView: UITableView!
    let imageView: UIImageView!
    let searchButton: UIButton!
    var searchTextField: UITextField?
    
    // Data
    let config: MarvelConfig!
    let dataSource: MarvelDatasource!
    
    private var viewModels: [MarvelListViewModel] = []
    private var totalViewModels = 0
    
    
    init(config: MarvelConfig, marvelDataSource: MarvelDatasource) {
        self.config = config
        self.dataSource = marvelDataSource
        self.imageView = UIImageView(image: UIImage(named: config.headerImageName) )
        self.tableView = UITableView()
        self.searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        super.init(nibName: nil, bundle: nil)
        
        searchButton.setImage(UIImage(named: "search_icon"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.enterSearchMode), for: .touchUpInside)
        imageView.contentMode = .scaleAspectFit
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.insertSubview(imageView, aboveSubview: tableView)
        view.insertSubview(searchButton, aboveSubview: imageView)
        
        tableView.backgroundColor = .clear
        imageView.backgroundColor = config.backgroundColor
        view.backgroundColor = config.backgroundColor
        
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tableView information
        tableView.contentInset = UIEdgeInsets(top: secureStatusBarHeight + HEADER_INSET - HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: config.tableViewCellToDisplay, bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Load initial content into the View Controller
        loadViewModels(offset: 0)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.frame = CGRect(x: view.safeAreaInsets.left, y: HEADER_HEIGHT, width: view.bounds.size.width, height: view.bounds.size.height - HEADER_HEIGHT)
        imageView.frame = CGRect(x: 0, y: secureStatusBarHeight, width: view.bounds.size.width, height: HEADER_INSET)
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Manage data
    
    private func loadViewModels(offset: Int, query: String? = nil) {
        dataSource.getMarvelResource(path: config.resourcePath,
                                     offset: offset,
                                     limit: 20,
                                     query: query,
                                     filterBy: config.apiFiltertingKey).done { response in
                                        
            self.totalViewModels = response.totalCount
            self.viewModels.append(contentsOf: self.config.viewModelMapper.viewModelsFromAPIResponse(response: response))
            self.tableView.reloadData()
        }.catch { error in
            // TODO: Handle error, probably an alert view that lets the user retry.
            print(error.localizedDescription)
        }
    }
    
    private func loadMoreViewsModelsIfNeeded(currentIndex: Int) {
        if currentIndex == viewModels.count - 3 && totalViewModels > viewModels.count {
            loadViewModels(offset: viewModels.count - 1)
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func newQueryToFilter(textField: UITextField) {
        if let text = textField.text, text.count >= 3 {
            viewModels = []
            tableView.reloadData()
            loadViewModels(offset: 0, query: text)
        }
    }
    
    @objc private func enterSearchMode() {
        let searchView = CustomSearchBarView.instanceFromNib()
        searchView.frame = searchButton.frame
        searchView.backgroundColor = config.backgroundColor
        searchView.tag = SEARCH_VIEW_TAG
        searchView.clearButton.addTarget(self, action: #selector(self.closeSearchMode), for: .touchUpInside)
        searchView.textField.addTarget(self, action: #selector(newQueryToFilter), for: .editingChanged)
        searchTextField = searchView.textField
        view.insertSubview(searchView, belowSubview: searchButton)
        UIView.animate(withDuration: 0.4) {
            searchView.frame = CGRect(x: 0, y: self.secureStatusBarHeight, width: self.view.bounds.size.width, height: self.HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsets(top: self.secureStatusBarHeight, left: 0, bottom: 0, right: 0)
            self.searchButton.alpha = 0.0
        }
    }
    
   @objc private func closeSearchMode() {
        viewModels = []
        tableView.reloadData()
        loadViewModels(offset: 0)
    
        let searchView = view.viewWithTag(SEARCH_VIEW_TAG)
        UIView.animate(withDuration: 0.4, animations: {
            searchView?.alpha = 0.0
            self.searchButton.alpha = 1.0
            self.tableView.contentInset = UIEdgeInsets(top: self.secureStatusBarHeight + self.HEADER_INSET - self.HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        }) { (success) in
            searchView?.removeFromSuperview()
        }
    }
    
    // MARK: - ScrollView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField?.resignFirstResponder()
        let y = secureStatusBarHeight + HEADER_INSET - (scrollView.contentOffset.y + HEADER_INSET)
        let height = min(max(y,HEADER_HEIGHT),UIScreen.main.bounds.size.height)
        imageView.frame = CGRect(x: 0, y: secureStatusBarHeight, width: UIScreen.main.bounds.size.width, height: height)
    }

    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MarvelListTableViewCell.cellHeights[config.tableViewCellToDisplay] ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check if we want to load more view Models
        loadMoreViewsModelsIfNeeded(currentIndex: indexPath.row)
        
        // Create and return current
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MarvelListTableViewCell else { return UITableViewCell() }
        let viewModel = viewModels[indexPath.row]
        cell.titleLabel.text = viewModel.name
        cell.subtitleLabel.text = viewModel.description
        if let imageUrl = viewModel.imageUrl {
            cell.marvelImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "hero_placeholder") ) { (image, error, cacheType, url) in
                if let image = image, let color = image.averageColor {
                    cell.backgroundImageView.image = UIImage.gradientImageWithBounds(bounds: cell.backgroundImageView.bounds, colors: [self.config.backgroundColor.cgColor, color.cgColor])
                }
            }
        } else {
            let placeHolderImage = UIImage(named: "hero_placeholder")
            let color = placeHolderImage?.averageColor
            cell.marvelImageView.image = placeHolderImage
            if let color = color {
                cell.backgroundImageView.image = UIImage.gradientImageWithBounds(bounds: cell.backgroundImageView.bounds, colors: [self.config.backgroundColor.cgColor, color.cgColor])
            }
            
        }
        return cell
    }
}


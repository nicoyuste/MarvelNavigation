//
//  MasterViewController.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 17/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit



class MarvelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var HEADER_INSET = CGFloat(200)
    var HEADER_HEIGHT: CGFloat {
        get {
            return CGFloat(100) + view.safeAreaInsets.top
        }
    }
    
    // UI
    let tableView: UITableView!
    let imageView: UIImageView!
    
    // Data
    let config: MarvelConfig!
    let dataSource: MarvelDatasource!
    private var objects: [MarvelListViewModel] = []
    
    
    init(config: MarvelConfig, marvelDataSource: MarvelDatasource) {
        self.config = config
        self.dataSource = marvelDataSource
        self.imageView = UIImageView(image: UIImage(named: config.headerImageName))
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
        
        self.imageView.contentMode = .center
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = config.backgroundColor
        
        // Set tableView information
        tableView.contentInset = UIEdgeInsets(top: HEADER_INSET, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Load initial content into the View Controller
        dataSource.getMarvelResource(path: config.resourcePath, offset: 0, limit: 20).done { response in
            self.objects = self.config.viewModelMapper.viewModelsFromAPIResponse(response: response)
            self.tableView.reloadData()
        }.catch { error in
            print(error.localizedDescription)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView.frame = CGRect(x: 0, y: HEADER_HEIGHT, width: view.bounds.size.width, height: view.bounds.size.height - HEADER_HEIGHT)
        view.addSubview(tableView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: HEADER_INSET)
        view.insertSubview(imageView, belowSubview: tableView)
    
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    // MARK: - ScrollView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = HEADER_INSET - (scrollView.contentOffset.y + HEADER_INSET)
        let height = min(max(y,HEADER_HEIGHT),UIScreen.main.bounds.size.height)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }

    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.backgroundColor = .blue
        cell.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: HEADER_HEIGHT)
        cell.textLabel!.text = object.name
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


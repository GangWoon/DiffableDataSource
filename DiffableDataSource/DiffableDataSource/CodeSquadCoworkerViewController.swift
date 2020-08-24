//
//  CodeSquadCoworkerViewController.swift
//  DiffableDataSource
//
//  Created by Cloud on 2020/08/21.
//  Copyright © 2020 Cloud. All rights reserved.
//

import UIKit

final class CodeSquadCoworkerViewController: UITableViewController {
    
    // MARK: - Properties
    private var searchController: UISearchController = .init(searchResultsController: nil)
    private var viewModel: CodeSquadCowerWorkerViewModel = .init()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Methods
    func configure() {
        tableView.dataSource = viewModel
        tableView
            .register(CoworkerTableViewCell.self,
                      forCellReuseIdentifier: CoworkerTableViewCell.identifier)
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Developer"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension CodeSquadCoworkerViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.developers = viewModel.filteredDeveloper(for: searchController.searchBar.text)
        tableView.reloadData()
    }
}

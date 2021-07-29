//
//  MemberListViewController.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/22.
//

import UIKit
import Combine

final class MemberListViewController: UITableViewController {
    
    // MARK: - Properties
    var dispatch: ((Action) -> Void)?
    private var dataSource: UITableViewDiffableDataSource<Section, Member>?
    private let theme: Theme
    private let scheduler: DispatchQueue
    @Published private var queryString: String
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    init(_ theme: Theme = .default, scheduler: DispatchQueue) {
        self.theme = theme
        self.scheduler = scheduler
        queryString = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch?(.loadInitialData)
        build()
    }
    
    // MARK: - Methods
    func update(with state: ViewState) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Member>()
        snapShot.appendSections([.main])
        snapShot.appendItems(state.members)
        dataSource?.apply(snapShot)
    }
    
    private func build() {
        dataSource = .init(tableView: tableView) { tableView, indexPath, member in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MemeberRow.identifier,
                for: indexPath
            ) as? MemeberRow
            cell?.update(with: member)
            
            return cell
        }
        buildListView()
        buildSearchController()
        buildAddMemberItem()
        cancellable = $queryString
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: scheduler)
            .sink { [weak self] queryString in
                self?.dispatch?(.didChangedSearchBar(queryString))
            }
    }
    
    private func buildListView() {
        tableView.register(
            MemeberRow.self,
            forCellReuseIdentifier: MemeberRow.identifier
        )
        tableView.separatorInset.left = .zero
        tableView.rowHeight = 110
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
    }
    
    private func buildSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = theme.placeHodler
        navigationItem.searchController = searchController
        navigationItem.title = theme.navigationTitle
    }
    
    private func buildAddMemberItem() {
        let action = UIAction { _ in
            self.dispatch?(.didTapAddMemberButton)
        }
        let item = UIBarButtonItem(
            systemItem: .add,
            primaryAction: action,
            menu: nil
        )
        navigationItem.rightBarButtonItem = item
    }
}

// MARK: - UISearchResultsUpdating
extension MemberListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        queryString = searchController.searchBar.text ?? ""
    }
}

extension MemberListViewController {
    final class MemeberRow: UITableViewCell {
        
        // MARK: - Views
        private lazy var profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        private lazy var nameLabel: UILabel = {
            let label = UILabel()
            label.font = theme.nameFont
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        private lazy var bioLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = .zero
            label.font = theme.bioFont
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        // MARK: - Properties
        static let identifier: String = "MemeberRow"
        private let theme: Theme = .default
        
        // MARK: - Lifecycle
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            build()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Methods
        func update(with state: Member) {
            profileImageView.image = state.image
            nameLabel.text = state.name + " / " + state.team.description
            bioLabel.text = state.bio
        }
        
        private func build() {
            buildHStack(with: buildVStack())
        }
        
        private func buildHStack(with vStack: UIStackView) {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8
            hStack.addArrangedSubview(profileImageView)
            hStack.addArrangedSubview(vStack)
            addSubview(hStack)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                hStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                
                profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
                profileImageView.heightAnchor.constraint(equalTo: hStack.heightAnchor)
            ])
        }
        
        private func buildVStack() -> UIStackView {
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.alignment = .top
            vStack.addArrangedSubview(nameLabel)
            vStack.addArrangedSubview(bioLabel)
            vStack.translatesAutoresizingMaskIntoConstraints = false
            bioLabel.heightAnchor.constraint(equalTo: vStack.heightAnchor, multiplier: 0.8).isActive = true
            
            return vStack
        }
    }
}

extension MemberListViewController.MemeberRow {
    struct Theme {
        static let `default` = Self(
            nameFont: .systemFont(ofSize: 14, weight: .semibold),
            bioFont: .systemFont(ofSize: 12, weight: .light)
        )
        let nameFont: UIFont
        let bioFont: UIFont
    }
}

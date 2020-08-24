//
//  CodeSquadCowerWorkerViewModel.swift
//  DiffableDataSource
//
//  Created by Cloud on 2020/08/24.
//  Copyright © 2020 Cloud. All rights reserved.
//

import UIKit

final class CodeSquadCowerWorkerViewModel: UITableViewDiffableDataSource<SpecialList, Developer> {
    
    // MARK: - Properties
    var specialList: [SpecialList]
    
    // MARK: - Lifecycle
    init(_ tableView: UITableView, specialList: [SpecialList] = SpecialList.red) {
        self.specialList = specialList
        super.init(tableView: tableView) { tableView, indexPath, developer in
            let cell = tableView.dequeueReusableCell(withIdentifier: CoworkerTableViewCell.identifier,
                                                     for: indexPath) as? CoworkerTableViewCell
            cell?
                .apply(name: developer.name,
                       age: developer.age)
            
            return cell
        }
        
    }
    
    // MARK: - Methods
    func filteredDeveloper(for queryOrNil: String?) -> [SpecialList] {
        let specialList = SpecialList.red
        guard let query = queryOrNil,
            !query.isEmpty else { return specialList }
        
        return specialList
            .filter { specialList in
                var matches = specialList.team.description.lowercased().contains(query.lowercased())
                for developer in specialList.developers {
                    if developer.name.lowercased().contains(query.lowercased()) {
                        matches = true
                        break
                    }
                }
                
                return matches
        }
    }
    
    func applySnapshot(_ animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SpecialList, Developer>()
        snapshot
            .appendSections(specialList)
        specialList
            .forEach { specialList in
                snapshot
                    .appendItems(specialList.developers,
                                 toSection: specialList)
        }
        apply(snapshot,
              animatingDifferences: animatingDifferences)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return specialList[section].team.description
    }
}

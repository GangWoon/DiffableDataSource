//
//  CodeSquadCowerWorkerViewModel.swift
//  DiffableDataSource
//
//  Created by Cloud on 2020/08/24.
//  Copyright © 2020 Cloud. All rights reserved.
//

import UIKit

final class CodeSquadCowerWorkerViewModel: NSObject {
    
    // MARK: - Properties
    var developers: [Developer]
    
    // MARK: - Lifecycle
    init(_ developers: [Developer] = Developer.SpeciaList) {
        self.developers = developers
    }
    
    // MARK: - Methods
    func filteredDeveloper(for queryOrNil: String?) -> [Developer] {
        let developers = Developer.SpeciaList
        guard let query = queryOrNil,
            !query.isEmpty else { return developers }
        
        return developers
            .filter { $0.name.lowercased().contains(query.lowercased()) }
    }
}

extension CodeSquadCowerWorkerViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return developers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: CoworkerTableViewCell.identifier,
                                 for: indexPath) as? CoworkerTableViewCell else { return .init() }
        let item = developers[indexPath.item]
        cell
            .apply(name: item.name,
                   age: item.age,
                   team: item.team.description)
        
        return cell
    }
}

//
//  MemberListViewController+Extension.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/22.
//

import UIKit

extension MemberListViewController {
    
    struct Theme {
        static let `default` = Self(
            navigationTitle: "CodeSquad Members",
            placeHodler: "Search Developers"
        )
        let navigationTitle: String
        let placeHodler: String
    }
    
    enum Section {
        case main
    }
    
    enum Team: CaseIterable, CustomStringConvertible {
        case iOS
        case backend
        case frontend
        static var dummy: Self {
            Self.allCases.randomElement() ?? .iOS
        }
        var description: String {
            switch self {
            case .iOS:
                return "iOS"
            case .backend:
                return "Backend"
            case .frontend:
                return "Frontend"
            }
        }
    }
    
    struct Member: Identifiable, Hashable {
        static var dummy: Self {
            Self(
                id: UUID().uuidString,
                image: .profile,
                name: .name,
                team: .dummy,
                bio: .bio
            )
        }
        var id: String
        var image: UIImage?
        var name: String
        var team: Team
        var bio: String
    }
    
    struct ViewState {
        var members: [Member]
    }
    
    enum Action {
        case loadInitialData
        case didChangedSearchBar(String)
    }
}

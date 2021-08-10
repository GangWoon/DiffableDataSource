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
    
    enum Action: Equatable {
        case loadInitialData
        case didChangedSearchBar(query: String)
        case didTapAddMemberButton
        case addMember(name: String, team: Team)
        case didSelectMember(row: Int)
        case editMember(row: Int, profile: UIImage?, bio: String?)
    }
    
    struct ViewState {
        var members: [Member]
    }
    
    enum Section {
        case main
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
        var bio: String?
    }
}

enum Team: Int, CaseIterable, CustomStringConvertible {
    
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

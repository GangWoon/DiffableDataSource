//
//  DetailMemberViewController+Extension.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/11.
//

import UIKit

extension DetailMemberViewController {
    
    struct Theme {
        static let `default` = Self(
            titleFont: .systemFont(ofSize: 16, weight: .bold),
            detailFont: .systemFont(ofSize: 14, weight: .light),
            backgroundColor: .white,
            textViewBorderColor: .secondarySystemFill,
            backButtonImage: UIImage(systemName: "chevron.backward")
        )
        let titleFont: UIFont
        let detailFont: UIFont
        let backgroundColor: UIColor
        let textViewBorderColor: UIColor
        let backButtonImage: UIImage?
    }
    
    enum Action {
        case profileImageTapped
        case textViewChanged(String)
        case backButtonTapped
    }
    
    struct ViewState: Equatable {
        var profile: UIImage?
        var name: String?
        var team: String?
        var bio: String?
    }
    
    enum SubViewStackType: CustomStringConvertible {
        
        case name
        case team
        
        var description: String {
            switch self {
            case .name:
                return "name:"
            case .team:
                return "team:"
            }
        }
    }
}

//
//  AddMemberViewController+Extension.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/11.
//

import UIKit

extension AddMemberViewController {
    
    struct Theme {
        
        struct Text {
            static let `default` = Self(
                name: "Name",
                team: "Team",
                placeholder: "Input your name.",
                button: "Select"
            )
            let name: String
            let team: String
            let placeholder: String
            let button: String
        }
        
        struct Color {
            static let `default` = Self(
                selectedTeam: .systemOrange,
                button: .systemIndigo
            )
            let selectedTeam: UIColor
            let button: UIColor
        }
        
        static let `default` = Self(
            text: .default,
            color: .default,
            labelFont: .boldSystemFont(ofSize: 17)
        )
        let text: Text
        let color: Color
        let labelFont: UIFont
    }
    
    enum Action {
        case didChangeTextField(String)
        case didSelectTeam(Int)
        case addMember
    }
}


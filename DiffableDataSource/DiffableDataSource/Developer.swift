//
//  Developer.swift
//  DiffableDataSource
//
//  Created by Cloud on 2020/08/24.
//  Copyright © 2020 Cloud. All rights reserved.
//

import Foundation

enum Team: CaseIterable, CustomStringConvertible {
    case iOS
    case BackEnd
    case FrontEnd
    
    var description: String {
        switch self {
        case .iOS:
            return "iOS"
        case .BackEnd:
            return "BackEnd"
        case .FrontEnd:
            return "FrontEnd"
        }
    }
}

struct Developer {
    var name: String
    var age: Int
    var team: Team
}

extension Developer {
    static let SpeciaList: [Developer] = [
        Developer(name: "Tozzi", age: 33, team: .iOS),
        Developer(name: "Lin", age: 27, team: .iOS),
        Developer(name: "Olaf", age: 21, team: .iOS),
        Developer(name: "Sally", age: 20, team: .FrontEnd),
        Developer(name: "Taek", age: 21, team: .FrontEnd),
        Developer(name: "Lia", age: 24, team: .FrontEnd),
        Developer(name: "Jay", age: 21, team: .BackEnd),
        Developer(name: "Solar", age: 24, team: .BackEnd),
        Developer(name: "Poogle", age: 25, team: .BackEnd),
    ]
}

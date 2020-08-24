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

struct Developer: Hashable {
    var id: UUID = .init()
    var name: String
    var age: Int
}

struct SpecialList: Hashable {
    var id: UUID = .init()
    var team: Team
    var developers: [Developer]
}

extension SpecialList {
    static let red: [SpecialList] = [
        SpecialList(team: .iOS,
                    developers: [
                        Developer(name: "Tozzi", age: 33),
                        Developer(name: "Lin", age: 27),
                        Developer(name: "Olaf", age: 21)]),
        SpecialList(team: .BackEnd,
                    developers: [
                        Developer(name: "Jay", age: 21),
                        Developer(name: "Solar", age: 24),
                        Developer(name: "Poogle", age: 25)]),
        SpecialList(team: .FrontEnd,
                    developers: [
                        Developer(name: "Sally", age: 20),
                        Developer(name: "Taek", age: 21),
                        Developer(name: "Lia", age: 24)])
    ]
}

//
//  AddMemberStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/29.
//

import UIKit
import Combine

final class AddMemberStore {
    
    struct State: Equatable {
        static var empty = Self(name: "", team: .iOS)
        var name: String
        var team: Team
    }
    
    struct Reducer {
        
        typealias Action = AddMemberViewController.Action
        let environment: Environment
        
        func reduce(_ action: Action, state: inout State) {
            switch action {
                
            case let .didChangeTextField(name):
                state.name = name
                
            case let .didSelectTeam(index):
                state.team = Team(rawValue: index) ?? .iOS
                
            case .addMember:
                environment.onDismissSubject
                    .send((state.name, state.team))
            }
        }
    }
    
    struct Environment {
        let scheduler: DispatchQueue
        let onDismissSubject: PassthroughSubject<(String, Team), Never>
    }
    
    //MARK: - Properties
    private var reducer: Reducer {
        Reducer(environment: environment)
    }
    var updateView: ((String) -> Void)?
    @Published private(set) var state: State
    private let environment: Environment
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    init(
        state: State,
        environment: Environment
    ) {
        self.state = state
        self.environment = environment
        cancellable = $state
            .removeDuplicates()
            .sink { [weak self] state in
                self?.updateView?(state.team.description)
            }
    }
    
    // MARK: - Methods
    func dispatch(_ action: AddMemberViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

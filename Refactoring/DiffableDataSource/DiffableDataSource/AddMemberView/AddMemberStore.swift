//
//  AddMemberStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/29.
//

import UIKit
import Combine

final class AddMemberStore {
    
    struct State {
        static var empty = Self(name: "", team: .iOS)
        var name: String
        var team: Team
    }
    
    struct Environment {
        let onDismissSubject: PassthroughSubject<(String, Team), Never>
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
    
    //MARK: - Properties
    private var reducer: Reducer {
        Reducer(environment: environment)
    }
    var updateView: ((String) -> Void)?
    private let environment: Environment
    @Published private(set) var state: State
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    init(
        state: State,
        environment: Environment
    ) {
        self.state = state
        self.environment = environment
        cancellable = $state
            .sink { [weak self] state in
                self?.updateView?(state.team.description)
            }
    }
    
    // MARK: - Methods
    func dispatch(_ action: AddMemberViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

//
//  MemberListStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/24.
//

import UIKit
import Combine

final class MemberListStore {
    
    struct State: Hashable {
        static var empty = Self(
            queryString: "",
            members: [],
            filterd: []
        )
        var queryString: String
        var members: [MemberListViewController.Member]
        var filterd: [MemberListViewController.Member]
    }
    
    struct Environment {
        var dispatch: DispatchQueue
        var fetchMembers: () -> [MemberListViewController.Member]
    }
    
    struct Reducer {
        
        let environment: Environment
        
        func reduce(
            _ action: MemberListViewController.Action,
            state: inout State
        ) {
            switch action {
            
            case .loadInitialData:
                state.members = environment.fetchMembers()
                
            case let .didChangedSearchBar(queryString):
                state.filterd = state.members
                    .filter { $0.name.lowercased().contains(queryString.lowercased()) ||
                        $0.team.description.lowercased().contains(queryString.lowercased()) }
            }
        }
    }
    
    // MARK: - Properties
    private var reducer: Reducer {
        Reducer(environment: environment)
    }
    var updateView: ((MemberListViewController.ViewState) -> Void)?
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
            .sink { [weak self] state in
                self?.updateView?(MemberListViewController.ViewState(state: state))
            }
    }
    
    // MARK: - Methods
    func dispath(_ action: MemberListViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

private extension MemberListViewController.ViewState {
    init(state: MemberListStore.State) {
        members = state.filterd.isEmpty ? state.members : state.filterd
    }
}

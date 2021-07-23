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
        var queryString: String?
        var members: [MemberListViewController.Member]
    }
    
    struct Environment {
        var dispatch: DispatchQueue
    }
    
    struct Reducer {
        
        let environment: Environment
        
        func reduce(
            _ action: MemberListViewController.Action,
            state: inout State
        ) {
            switch action {
            case let .didChangedSearchBar(queryString):
                state.queryString = queryString
            }
        }
    }
    
    // MARK: - Properties
    private var reducer: Reducer {
        Reducer(environment: environment)
    }
    var updateView: ((MemberListViewController.ViewState) -> Void)?
    @Published private var state: State
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
            .debounce(for: 0.5, scheduler: environment.dispatch)
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
        members = state.members
    }
}

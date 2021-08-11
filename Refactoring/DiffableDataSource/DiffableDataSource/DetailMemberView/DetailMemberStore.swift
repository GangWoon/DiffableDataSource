//
//  DetailMemberStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/10.
//

import UIKit
import Combine

final class DetailMemberStore {
    
    struct Environment {
        let dismissSubject: PassthroughSubject<(UIImage?, String?), Never>
        let scheduler: DispatchQueue
        let replaceProfileImage: (() -> UIImage?)
    }
    
    struct Reducer {
        
        let environment: Environment
        
        func reduce(
            _ action: DetailMemberViewController.Action,
            state: inout DetailMemberViewController.ViewState
        ) {
            switch action {
                
            case .profileImageTapped:
                state.profile = environment.replaceProfileImage()
                
            case let .textViewChanged(text):
                state.bio = text
                
            case .backButtonTapped:
                environment.dismissSubject
                    .send((state.profile, state.bio))
            }
        }
    }
    
    // MARK: - Properties
    private var reducer: Reducer {
        return Reducer(environment: environment)
    }
    var updateView: ((DetailMemberViewController.ViewState) -> Void)?
    @Published private(set) var state: DetailMemberViewController.ViewState
    private let environment: Environment
    private var cancellables: AnyCancellable?
    
    // MARK: - Lifecycle
    init(
        state: DetailMemberViewController.ViewState,
        environment: Environment
    ) {
        self.state = state
        self.environment = environment
        cancellables = $state
            .removeDuplicates()
            .subscribe(on: environment.scheduler)
            .sink { [weak self] state in
                self?.updateView?(state)
            }
    }
    
    // MARK: - Methods
    func dispatch(_ action: DetailMemberViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

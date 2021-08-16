//
//  DetailMemberStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/10.
//

import UIKit
import Combine

protocol DetailMemberViewActionDispatcher {
    func send(_ action: DetailMemberViewController.Action)
}

final class DetailMemberStore: DetailMemberViewActionDispatcher {
    
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
    @Published private(set) var state: DetailMemberViewController.ViewState
    private var dispatchSubject: PassthroughSubject<DetailMemberViewController.Action, Never>
    weak var updateSubject: PassthroughSubject<DetailMemberViewController.ViewState, Never>?
    private let environment: Environment
    private var cancellables: Set<AnyCancellable>
    
    // MARK: - Lifecycle
    init(
        state: DetailMemberViewController.ViewState,
        environment: Environment
    ) {
        self.state = state
        self.environment = environment
        dispatchSubject = .init()
        cancellables = .init()
        listen()
    }
    
    // MARK: - Methods
    func send(_ action: DetailMemberViewController.Action) {
        dispatchSubject.send(action)
    }
    
    private func listen() {
        listenState()
        listenAction()
    }
    
    private func listenState() {
        $state
            .removeDuplicates()
            .subscribe(on: environment.scheduler)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.updateSubject?.send(state)
            }
            .store(in: &cancellables)
    }
    
    private func listenAction() {
        dispatchSubject
            .sink { [weak self] action in
                guard let self = self else { return }
                self.reducer.reduce(action, state: &self.state)
            }
            .store(in: &cancellables)
    }
}

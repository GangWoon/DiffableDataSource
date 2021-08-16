//
//  AddMemberStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/29.
//

import UIKit
import Combine

protocol AddMemberViewActionDispatcher {
    func send(_ action: AddMemberViewController.Action)
}

final class AddMemberStore: AddMemberViewActionDispatcher {
    
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
    weak var updateSubject: PassthroughSubject<String, Never>?
    @Published private(set) var state: State
    private let dispatchSubject: PassthroughSubject<AddMemberViewController.Action, Never>
    private let environment: Environment
    private var cancellables: Set<AnyCancellable>
    
    // MARK: - Lifecycle
    init(
        state: State,
        environment: Environment
    ) {
        self.state = state
        dispatchSubject = .init()
        self.environment = environment
        cancellables = []
        listen()
    }
    
    // MARK: - Methods
    func send(_ action: AddMemberViewController.Action) {
        dispatchSubject.send(action)
    }
    
    private func listen() {
        listenState()
        listenAction()
    }
    
    private func listenState() {
        $state
            .removeDuplicates()
            .sink { [weak self] state in
                self?.updateSubject?.send(state.team.description)
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

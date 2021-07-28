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
    
    struct Navigator {
        
        typealias Item = (String, MemberListViewController.Team)
        
        let viewController: UIViewController
        
        func presentMemberRegisterView() -> AnyPublisher<Item, Never> {
            let subject = PassthroughSubject<Item, Never>()
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .destructive,
                handler: nil
            )
            let addAction = UIAlertAction(
                title: "Add",
                style: .destructive
            ) { _ in
                subject.send(("Hello", .iOS))
            }
            let alertController = UIAlertController(
                title: "Add Member",
                message: nil,
                preferredStyle: .alert
            )
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            
            viewController.present(
                alertController,
                animated: true,
                completion: nil
            )
            
            return subject
                .eraseToAnyPublisher()
        }
    }
    
    struct Environment {
        let dispatch: DispatchQueue
        let fetchMembers: () -> [MemberListViewController.Member]
        let uuid: () -> String
        let navigator: Navigator
    }
    
    struct Reducer {
        
        typealias Action = MemberListViewController.Action
        let environment: Environment
        
        func reduce(
            _ action: Action,
            state: inout State
        ) -> AnyPublisher<Action, Never>? {
            switch action {
            
            case .loadInitialData:
                state.members = environment.fetchMembers()
                
            case let .didChangedSearchBar(queryString):
                state.filterd = state.members
                    .filter { $0.name.lowercased().contains(queryString.lowercased()) ||
                        $0.team.description.lowercased().contains(queryString.lowercased()) }
                
            case .didTapAddMemberButton:
                return environment.navigator.presentMemberRegisterView()
                    .receive(on: environment.dispatch)
                    .map { Action.addMember($0.0, $0.1) }
                    .eraseToAnyPublisher()
                
            case let .addMember(name, team):
                let newMember = MemberListViewController.Member(
                    id: environment.uuid(),
                    image: .profile,
                    name: name,
                    team: team,
                    bio: ""
                )
                state.members.insert(newMember, at: .zero)
            }
            
            return nil
        }
    }
    
    // MARK: - Properties
    private var reducer: Reducer {
        Reducer(environment: environment)
    }
    var updateView: ((MemberListViewController.ViewState) -> Void)?
    @Published private(set) var state: State
    private let environment: Environment
    private var cancellables: [AnyCancellable]
    
    // MARK: - Lifecycle
    init(
        state: State,
        environment: Environment
    ) {
        self.state = state
        self.environment = environment
        self.cancellables = []
        $state
            .sink { [weak self] state in
                self?.updateView?(MemberListViewController.ViewState(state: state))
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func dispath(_ action: MemberListViewController.Action) {
        reducer.reduce(action, state: &state)
            .map { effect in
                effect
                    .receive(on: environment.dispatch)
                    .sink(receiveValue: dispath(_:))
                    .store(in: &cancellables)
            }
    }
}

private extension MemberListViewController.ViewState {
    init(state: MemberListStore.State) {
        members = state.filterd.isEmpty ? state.members : state.filterd
    }
}

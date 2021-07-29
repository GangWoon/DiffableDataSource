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
        
        let viewController: UIViewController
        private let subject: PassthroughSubject<(String, Team), Never> = .init()
        private let alertControllerKey: String = "contentViewController"
        
        func presentMemberRegisterView(scheduler: DispatchQueue) -> AnyPublisher<(String, Team), Never> {
            let alertController = makeAlertController(with: scheduler)
            viewController.present(
                alertController,
                animated: true,
                completion: nil
            )
            
            return subject
                .eraseToAnyPublisher()
        }
        
        private func makeAlertController(with scheduler: DispatchQueue) -> UIViewController {
            let store = AddMemberStore(
                state: .empty,
                environment: AddMemberStore.Environment(onDismissSubject: subject)
            )
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .destructive,
                handler: nil
            )
            let addAction = UIAlertAction(
                title: "Add",
                style: .default
            ) { _ in
                store.dispatch(.addMember)
            }
            let alertController = UIAlertController(
                title: "Add Member",
                message: nil,
                preferredStyle: .alert
            )
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            
            let addmemberViewController = AddMemberViewController(scheduler: scheduler)
            addmemberViewController.dispatch = store.dispatch
            store.updateView = addmemberViewController.updateView
            
            alertController.setValue(addmemberViewController, forKey: alertControllerKey)
            addmemberViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addmemberViewController.view.widthAnchor.constraint(equalToConstant: viewController.view.frame.width * 0.72)
            ])
            
            return alertController
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
                return environment.navigator.presentMemberRegisterView(scheduler: environment.dispatch)
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
    private var cancellables: Set<AnyCancellable>
    
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

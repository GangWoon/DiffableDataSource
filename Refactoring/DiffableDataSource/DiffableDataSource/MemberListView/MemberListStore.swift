//
//  MemberListStore.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/24.
//

import UIKit
import Combine

protocol MemberListStoreNavigator {
    func presentAddMemberView() -> AnyPublisher<(String, Team), Never>
    func presentDetailMemberView(member: MemberListViewController.Member) -> AnyPublisher<(UIImage?, String?), Never>
}

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
    
    struct Navigator: MemberListStoreNavigator {
        
        struct Container {
            let scheduler: DispatchQueue
        }
        
        let viewController: UIViewController
        let container: Container
        private let alertControllerKey: String = "contentViewController"
        
        init(viewController: UIViewController, container: Container) {
            self.viewController = viewController
            self.container = container
        }
        
        func presentAddMemberView() -> AnyPublisher<(String, Team), Never> {
            let subject = PassthroughSubject<(String, Team), Never>()
            
            let alertController = makeAlertController(subject: subject)
            viewController.present(
                alertController,
                animated: true,
                completion: nil
            )
            
            return subject
                .eraseToAnyPublisher()
        }
        
        func presentDetailMemberView(member: MemberListViewController.Member) -> AnyPublisher<(UIImage?, String?), Never> {
            let subject = PassthroughSubject<(UIImage?, String?), Never>()
            
            let detailViewController = DetailMemberViewController()
            let state = DetailMemberViewController.ViewState(
                profile: member.image,
                name: member.name,
                team: member.team.description,
                bio: member.bio
            )
            let environment = DetailMemberStore.Environment(
                dismissSubject: subject,
                scheduler: container.scheduler,
                replaceProfileImage: { .profile }
            )
            let store = DetailMemberStore(state: state, environment: environment)
            
            detailViewController.dispatchSubject = store
            store.updateSubject = detailViewController.updateSubject
            
            viewController.show(detailViewController, sender: viewController)
            
            return subject
                .map { item in
                    viewController.navigationController?.isNavigationBarHidden.toggle()
                    viewController.navigationController?.popViewController(animated: true)
                    
                    return item
                }
                .eraseToAnyPublisher()
        }
        
        private func makeAlertController(subject: PassthroughSubject<(String, Team), Never>) -> UIViewController {
            let addmemberViewController = AddMemberViewController()
            let store = AddMemberStore(
                state: .empty,
                environment: AddMemberStore.Environment(
                    scheduler: container.scheduler,
                    onDismissSubject: subject
                )
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
        let scheduler: DispatchQueue
        let fetchMembers: () -> [MemberListViewController.Member]
        let uuid: () -> String
        let image: () -> UIImage
        let navigator: MemberListStoreNavigator
    }
    
    struct Reducer {
        
        typealias Action = MemberListViewController.Action
        let environment: Environment
        
        @discardableResult
        func reduce(
            _ action: Action,
            state: inout State
        ) -> AnyPublisher<Action, Never>? {
            switch action {
                
            case .loadInitialData:
                state.members = environment.fetchMembers()
                
            case let .searchBarChanged(queryString):
                state.filterd = state.members
                    .filter { $0.name.lowercased().contains(queryString.lowercased()) ||
                        $0.team.description.lowercased().contains(queryString.lowercased()) }
                
            case .addMemberButtonTapped:
                return environment.navigator.presentAddMemberView()
                    .receive(on: environment.scheduler)
                    .map { Action.addMember(name: $0.0, team: $0.1) }
                    .eraseToAnyPublisher()
                
            case let .addMember(name, team):
                let newMember = MemberListViewController.Member(
                    id: environment.uuid(),
                    image: environment.image(),
                    name: name,
                    team: team,
                    bio: ""
                )
                state.members.insert(newMember, at: .zero)
            case let .memberRowTapped(row):
                let member = state.members[row]
                return environment.navigator.presentDetailMemberView(member: member)
                    .receive(on: environment.scheduler)
                    .map { Action.editMember(row: row, profile: $0.0, bio: $0.1) }
                    .eraseToAnyPublisher()
                
            case let .editMember(row: row, profile: profile, bio: bio):
                state.members[row].image = profile
                state.members[row].bio = bio
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
            .removeDuplicates()
            .subscribe(on: environment.scheduler)
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
                    .receive(on: environment.scheduler)
                    .sink(receiveValue: dispath)
                    .store(in: &cancellables)
            }
    }
}

private extension MemberListViewController.ViewState {
    init(state: MemberListStore.State) {
        members = state.filterd.isEmpty ? state.members : state.filterd
    }
}

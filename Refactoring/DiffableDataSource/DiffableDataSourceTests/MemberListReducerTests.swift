//
//  MemberListReducerTests.swift
//  MemberListReducerTests
//
//  Created by Cloud on 2021/07/22.
//

import XCTest
import Combine
@testable import DiffableDataSource

class MemberListReducer: XCTestCase {
    
    private var cancellable: AnyCancellable?
    
    func testLoadInitialData_noEffect() {
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { [.neil] },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: MockNavigator()
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        reducer.reduce(.loadInitialData, state: &state)
        XCTAssertEqual(state.members, [.neil])
    }
    
    func testDidChangedSearchBar_noEffect() {
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: MockNavigator()
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State(
            queryString: "",
            members: [.neil, .gangwoon],
            filterd: []
        )
        reducer.reduce(.didChangedSearchBar("neil"), state: &state)
        XCTAssertEqual(state.filterd, [.neil])
    }
    
    func testTapAddMemberButton_noEffect() {
        let exp = expectation(description: "present AddMemberView")
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { "00001" },
            image: { UIImage(systemName: "xmark")! },
            navigator: MockNavigator(
                handler: {
                    exp.fulfill()
                },
                subject: subject
            )
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        reducer.reduce(.didTapAddMemberButton, state: &state)
        wait(for: [exp], timeout: 1)
    }
    
    func testTapAddMemberButton_1Effect() {
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: MockNavigator(subject: subject)
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        let effect = reducer.reduce(.didTapAddMemberButton, state: &state)
        cancellable = effect?
            .sink(receiveValue: { action in
                XCTAssertEqual(action, MemberListViewController.Action.addMember("", .iOS))
            })
        subject.send(("Lin", .iOS))
    }
    
    func testAddMember_noEffect() {
        let neil = MemberListViewController.Member(
            id: "00001",
            image: UIImage(systemName: "xmark")!,
            name: "Neil",
            team: .backend,
            bio: ""
        )
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { "00001" },
            image: { UIImage(systemName: "xmark")! },
            navigator: MockNavigator()
        )
        
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        reducer.reduce(.addMember("Neil", .backend), state: &state)
        XCTAssertEqual(state.members.first!, neil)
    }
}

private extension MemberListViewController.Member {
    static let neil = MemberListViewController.Member(
        id: UUID().uuidString,
        image: nil,
        name: "Neil",
        team: .iOS,
        bio: ""
    )
    
    static let gangwoon = MemberListViewController.Member(
        id: UUID().uuidString,
        image: nil,
        name: "GangWoon",
        team: .backend,
        bio: ""
    )
}

struct MockNavigator: MemberListStoreNavigator {
    
    var handler: (() -> Void)?
    var subject: PassthroughSubject<(String, Team), Never>?
    
    func presentAddMemberView(scheduler: DispatchQueue) -> AnyPublisher<(String, Team), Never> {
        handler?()
        return subject!
            .eraseToAnyPublisher()
    }
}

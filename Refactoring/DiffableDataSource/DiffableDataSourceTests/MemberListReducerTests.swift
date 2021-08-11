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
    
    func testSearchBarChanged_noEffect() {
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
        reducer.reduce(.searchBarChanged(query: "neil"), state: &state)
        XCTAssertEqual(state.filterd, [.neil])
    }
    
    func testAddMemberButtonTapped_noEffect() {
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
                addMemberSubject: subject
            )
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        reducer.reduce(.addMemberButtonTapped, state: &state)
        wait(for: [exp], timeout: 1)
    }
    
    func testAddMemberButtonTapped_1Effect() {
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: MockNavigator(addMemberSubject: subject)
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        let effect = reducer.reduce(.addMemberButtonTapped, state: &state)
        cancellable = effect?
            .sink(receiveValue: { action in
                XCTAssertEqual(action, MemberListViewController.Action.addMember(name: "", team: .iOS))
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
        reducer.reduce(.addMember(name: "Neil", team: .backend), state: &state)
        XCTAssertEqual(state.members.first!, neil)
    }
    
    func testMemberRowTapped_noEffect() {
        let exp = expectation(description: "MemberRowTapped_noEffect")
        let navigator = MockNavigator(
            handler: { exp.fulfill() },
            detailMemberSubejct: .init()
        )
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: navigator
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        state.members = [.gangwoon]
        reducer.reduce(.memberRowTapped(row: .zero), state: &state)
        wait(for: [exp], timeout: 1)
    }
    
    func testMemberRowTapped_1Effect() {
        let subject = PassthroughSubject<(UIImage?, String?), Never>()
        let navigator = MockNavigator(detailMemberSubejct: subject)
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: navigator
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        state.members = [.gangwoon]
        let effect = reducer.reduce(.memberRowTapped(row: .zero), state: &state)
        let dummyImage = UIImage(systemName: "xmark")
        let dummyBio = "Hello"
        cancellable = effect?
            .sink(receiveValue: { action in
                XCTAssertEqual(action, MemberListViewController.Action.editMember(row: .zero, profile: dummyImage, bio: dummyBio))
            })
        subject.send((dummyImage, dummyBio))
    }
    
    func testEditMember_noEffect() {
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { fatalError("Should not be called.") },
            uuid: { fatalError("Should not be called.") },
            image: { fatalError("Should not be called.") },
            navigator: MockNavigator()
        )
        let reducer = MemberListStore.Reducer(environment: environment)
        var state = MemberListStore.State.empty
        state.members = [.neil]
        let dummyImage = UIImage(systemName: "xmark")
        let dummyBio = "Hello"
        reducer.reduce(.editMember(row: .zero, profile: dummyImage, bio: dummyBio), state: &state)
        XCTAssertEqual(state.members.first?.image, dummyImage)
        XCTAssertEqual(state.members.first?.bio, dummyBio)
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
    var addMemberSubject: PassthroughSubject<(String, Team), Never> = .init()
    var detailMemberSubejct: PassthroughSubject<(UIImage?, String?), Never> = .init()
    
    func presentAddMemberView() -> AnyPublisher<(String, Team), Never> {
        handler?()
        return addMemberSubject
            .eraseToAnyPublisher()
    }
    
    func presentDetailMemberView(member: MemberListViewController.Member) -> AnyPublisher<(UIImage?, String?), Never> {
        handler?()
        return detailMemberSubejct
            .eraseToAnyPublisher()
    }
}

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
    
    func testLoadInitialData() {
        let store = MemberListStore(
            state: .empty,
            environment: .init(
                scheduler: .main,
                fetchMembers: { [.neil] },
                uuid: { fatalError("Should not be called.") },
                image: { fatalError("Should not be called.") },
                navigator: MockNavigator()
            )
        )
        store.dispath(.loadInitialData)
        XCTAssertEqual(store.state.members, [.neil])
    }
    
    func testFilterWithQuery() {
        let store = MemberListStore(
            state: .init(
                queryString: "",
                members: [.neil, .gangwoon],
                filterd: []
            ),
            environment: .init(
                scheduler: .main,
                fetchMembers: { fatalError("Should not be called.") },
                uuid: { fatalError("Should not be called.") },
                image: { fatalError("Should not be called.") },
                navigator: MockNavigator()
            )
        )
        store.dispath(.didChangedSearchBar("neil"))
        XCTAssertEqual(store.state.filterd, [.neil])
    }
    
    func testTapAddMemberButton() {
        let exp = expectation(description: "present AddMemberView")
        let subject = PassthroughSubject<Void, Never>()
        cancellable = subject
            .sink {
                exp.fulfill()
            }
        let store = MemberListStore(
            state: .init(
                queryString: "",
                members: [],
                filterd: []
            ),
            environment: .init(
                scheduler: .main,
                fetchMembers: { fatalError("Should not be called.") },
                uuid: {
                    return "00001"
                },
                image: { UIImage(systemName: "xmark")! },
                navigator: MockNavigator(subject: subject)
            )
        )
        store.dispath(.didTapAddMemberButton)
        wait(for: [exp], timeout: 1)
    }
    
    func testAddMember() {
        let store = MemberListStore(
            state: .init(
                queryString: "",
                members: [],
                filterd: []
            ),
            environment: .init(
                scheduler: .main,
                fetchMembers: { fatalError("Should not be called.") },
                uuid: { "00001" },
                image: { UIImage(systemName: "xmark")! },
                navigator: MockNavigator()
            )
        )
        
        let neil = MemberListViewController.Member(
            id: "00001",
            image: UIImage(systemName: "xmark")!,
            name: "Neil",
            team: .iOS,
            bio: ""
        )
        store.dispath(.addMember("Neil", .iOS))
        XCTAssertEqual(store.state.members.first!, neil)
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
   
    var subject: PassthroughSubject<(Void), Never>?
    
    func presentAddMemberView(scheduler: DispatchQueue) -> AnyPublisher<(String, Team), Never> {
        subject!.send()
        
        return Just(("Neil", .iOS))
            .eraseToAnyPublisher()
    }
}

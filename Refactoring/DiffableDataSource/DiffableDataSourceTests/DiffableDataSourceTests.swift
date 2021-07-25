//
//  DiffableDataSourceTests.swift
//  DiffableDataSourceTests
//
//  Created by Cloud on 2021/07/22.
//

import XCTest
@testable import DiffableDataSource

class DiffableDataSourceTests: XCTestCase {
    
    func testLoadInitialData() {
        let store = MemberListStore(
            state: .empty,
            environment: .init(
                dispatch: .main,
                fetchMembers: { [.neil] })
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
                dispatch: .main,
                fetchMembers: { fatalError("Should not be called.") }
            )
        )
        store.dispath(.didChangedSearchBar("neil"))
        XCTAssertEqual(store.state.filterd, [.neil])
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

//
//  AddMemberReducerTests.swift
//  DiffableDataSourceTests
//
//  Created by Cloud on 2021/08/01.
//

import XCTest
import Combine
@testable import DiffableDataSource

final class AddMemberReducerTests: XCTestCase {
    
    private var cancellable: AnyCancellable?
    
    func testDidChangeTextFieldAction_noEffect() {
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = AddMemberStore.Environment(scheduler: .main, onDismissSubject: subject)
        let reducer = AddMemberStore.Reducer(environment: environment)
        var state = AddMemberStore.State.empty
        reducer.reduce(.didChangeTextField("Hello"), state: &state)
        XCTAssertEqual(state.name, "Hello")
    }
    
    func testDidSelectTeam_noEffect() {
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = AddMemberStore.Environment(scheduler: .main, onDismissSubject: subject)
        let reducer = AddMemberStore.Reducer(environment: environment)
        var state = AddMemberStore.State.empty
        reducer.reduce(.didSelectTeam(2), state: &state)
        XCTAssertEqual(state.team, .frontend)
    }
    
    func testAddMember_1Effect() {
        let subject = PassthroughSubject<(String, Team), Never>()
        let environment = AddMemberStore.Environment(scheduler: .main, onDismissSubject: subject)
        let reducer = AddMemberStore.Reducer(environment: environment)
        var state = AddMemberStore.State.empty
        let exp = expectation(description: "Async call")
        cancellable = subject.sink { name, team in
            XCTAssertEqual("", name)
            XCTAssertEqual(.iOS, team)
            exp.fulfill()
        }
        reducer.reduce(.addMember, state: &state)
        wait(for: [exp], timeout: 1)
    }
}

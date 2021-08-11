//
//  DetailMemberStoreTests.swift
//  DiffableDataSourceTests
//
//  Created by Cloud on 2021/08/12.
//

import XCTest
import Combine
@testable import DiffableDataSource

final class DetailMemberStoreTests: XCTestCase {
    
    private var cancellable: AnyCancellable?
    
    func testProfileImageTapped_noEffect() {
        let dummyImage = UIImage(systemName: "xmark")
        let environment = DetailMemberStore.Environment(
            dismissSubject: .init(),
            scheduler: .main,
            replaceProfileImage: { dummyImage }
        )
        let reducer = DetailMemberStore.Reducer(environment: environment)
        var state = DetailMemberViewController.ViewState.dummy
        reducer.reduce(.profileImageTapped, state: &state)
        XCTAssertEqual(state.profile, dummyImage)
    }
    
    func testTextViewChanged_noEffect() {
        let dummyBio = "Hello"
        let environment = DetailMemberStore.Environment(
            dismissSubject: .init(),
            scheduler: .main,
            replaceProfileImage: { fatalError("Should not called") }
        )
        let reducer = DetailMemberStore.Reducer(environment: environment)
        var state = DetailMemberViewController.ViewState.dummy
        reducer.reduce(.textViewChanged(dummyBio), state: &state)
        XCTAssertEqual(state.bio, dummyBio)
    }
    
    func testBackButtonTapped() {
        let subject = PassthroughSubject<(UIImage?, String?), Never>()
        let dummyProfile = UIImage.checkmark
        let dummyBio = "Hello"
        let environment = DetailMemberStore.Environment(
            dismissSubject: subject,
            scheduler: .main,
            replaceProfileImage: { fatalError("Should not called") }
        )
        let reducer = DetailMemberStore.Reducer(environment: environment)
        var state = DetailMemberViewController.ViewState.dummy
        reducer.reduce(.backButtonTapped, state: &state)
        cancellable = subject
            .sink(receiveValue: { profile, bio in
                XCTAssertEqual(profile, dummyProfile)
                XCTAssertEqual(bio, dummyBio)
            })
        subject.send((dummyProfile, dummyBio))
    }
}

private extension DetailMemberViewController.ViewState {
    static var dummy = Self()
}

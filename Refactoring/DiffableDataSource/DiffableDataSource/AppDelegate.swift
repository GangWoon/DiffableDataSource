//
//  AppDelegate.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        let memberListViewController = MemberListViewController()
        let store = MemberListStore(
            state: MemberListStore.State(
                queryString: "",
                members: [
                    .dummy, .dummy, .dummy, .dummy,
                    .dummy, .dummy, .dummy, .dummy
                ]
            ),
            environment: MemberListStore.Environment(dispatch: .main)
        )
        store.updateView = memberListViewController.update
        memberListViewController.dispatch = store.dispath
        let navigationViewController = UINavigationController(rootViewController: memberListViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}


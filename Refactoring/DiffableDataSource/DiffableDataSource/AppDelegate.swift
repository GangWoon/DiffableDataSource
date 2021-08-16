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
        let navigationController = buildInitialViewController()
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func buildInitialViewController() -> UIViewController {
        let memberListViewController = MemberListViewController()
        let environment = MemberListStore.Environment(
            scheduler: .main,
            fetchMembers: { (0...9).map { _ in MemberListViewController.Member.dummy } },
            uuid: { UUID().uuidString },
            image: { .profile },
            navigator: MemberListStore.Navigator(
                viewController: memberListViewController,
                container: MemberListStore.Navigator.Container(scheduler: .main)
            )
        )
        let store = MemberListStore(state: .empty, environment: environment)
        
        store.updateSubject = memberListViewController.updateSubject
        memberListViewController.actionListener = store
        
        let navigationViewController = UINavigationController(rootViewController: memberListViewController)
        
        return navigationViewController
    }
}


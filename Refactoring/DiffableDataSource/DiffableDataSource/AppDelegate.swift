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
        let mainQueue = DispatchQueue.main
        let memberListViewController = MemberListViewController(scheduler: mainQueue)
        let environment = MemberListStore.Environment(
            dispatch: mainQueue,
            fetchMembers: { (0...9).map { _ in MemberListViewController.Member.dummy } },
            uuid: { UUID().uuidString },
            navigator: MemberListStore.Navigator(viewController: memberListViewController)
        )
        let store = MemberListStore(state: .empty, environment: environment)

        store.updateView = memberListViewController.update
        memberListViewController.dispatch = store.dispath
        
        let navigationViewController = UINavigationController(rootViewController: memberListViewController)
        
        return navigationViewController
    }
}


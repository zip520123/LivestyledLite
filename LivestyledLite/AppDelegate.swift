//
//  AppDelegate.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: RootCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigation = UINavigationController()
        if #available(iOS 11.0, *) {
            navigation.navigationBar.prefersLargeTitles = true
        } else {
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigation
        coordinator = RootCoordinator(navigationController: navigation)
        coordinator.start()
        window!.makeKeyAndVisible()
        return true
    }

   


}


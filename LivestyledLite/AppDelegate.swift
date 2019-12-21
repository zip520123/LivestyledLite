//
//  AppDelegate.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationBannerSwift
import Reachability
import RxReachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let db: DB = UserDefaultsDB()
    var window: UIWindow?
    var coordinator: RootCoordinator!
    let disposeBag = DisposeBag()
    var reachability: Reachability?
    

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
        
        setupReachability()
        
        
        return true
    }

    func setupReachability() {
        reachability = Reachability()
        try? reachability?.startNotifier()
        
        Reachability.rx.reachabilityChanged
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (reachability) in
                print("Reachability changed: \(reachability.connection.description)")
                if reachability.connection == .none {
                    let banner = NotificationBanner(title: "Error", subtitle: reachability.connection.description, style: .danger)
                    banner.show()
                } else {
                    let banner = NotificationBanner(title: "Connection using:", subtitle: reachability.connection.description, style: .success)
                    banner.show()
                }
            }).disposed(by: disposeBag)
    }


}


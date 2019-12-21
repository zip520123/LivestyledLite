//
//  Coordinator.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    init(navigationController: UINavigationController)
    func start()
}

final class RootCoordinator: NSObject, CoordinatorProtocol {
    private var navigation: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigation = navigationController
    }
    
    func start() {
        let vc = EventsViewController()
        vc.delegate = self
        navigation.setViewControllers([vc], animated: true)
    }
}

// MARK: - Source Related Methods
extension RootCoordinator: EventsViewControllerDelegate {
    func eventsViewController(eventsViewController: EventsViewController, didSelectEvent: LSEvent) {
        
    }
    
    
}

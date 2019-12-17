//
//  EventsViewController.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate: AnyObject {
    func eventsViewController(eventsViewController: EventsViewController, didSelectEvent: Event)
}
class EventsViewController: UIViewController {
    weak var delegate: EventsViewControllerDelegate?
    
    override func viewDidLoad() {
        title = "EventsViewController"
    }
    
    
    
}

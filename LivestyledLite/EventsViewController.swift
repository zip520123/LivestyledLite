//
//  EventsViewController.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit
import SnapKit
protocol EventsViewControllerDelegate: AnyObject {
    func eventsViewController(eventsViewController: EventsViewController, didSelectEvent: Event)
}
class EventsViewController: UIViewController {
    let tableView = UITableView()
    weak var delegate: EventsViewControllerDelegate?
    
    override func viewDidLoad() {
        setupUI()
        dataBinding()
    }
    
    func setupUI(){
        title = "Events"
        view.addSubview(tableView)
        
        layoutUI()
    }
    
    func layoutUI(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func dataBinding(){
        
    }
    
    
    
}

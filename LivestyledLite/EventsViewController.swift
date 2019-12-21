//
//  EventsViewController.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NotificationBannerSwift
protocol EventsViewControllerDelegate: AnyObject {
    func eventsViewController(eventsViewController: EventsViewController, didSelectEvent: LSEvent)
}
class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    var events = [LSEvent]()
    
    weak var delegate: EventsViewControllerDelegate?
    let viewModel = EventViewModel()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        setupUI()
        dataBinding()
        requestData()
    }
    
    func setupUI(){
        title = "Events"
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.refreshControl = refreshControl
        
        layoutUI()
    }
    
    func layoutUI(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func dataBinding(){
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else {return}
            self.events.removeAll()
            self.tableView.reloadData()
            
            self.viewModel.input.resetLoadingStep.acceptAction()
            self.viewModel.input.fetchEvents.acceptAction()
            
        }).disposed(by: disposeBag)
        
        viewModel.output.eventsResult.drive(onNext:{ [weak self] list in
            guard let `self` = self else {return}
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.events += list
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        tableView.rx.contentOffset.map { [weak self] (offset) -> Bool in
            guard let `self` = self else {return false}
            return offset.y + self.tableView.frame.height + 20.0 > self.tableView.contentSize.height }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.input.fetchNextPageEvents.acceptAction()
                
            }).disposed(by: disposeBag)
        
        viewModel.output.errorOutput.drive(onNext:{[weak self] error in
            self?.refreshControl.endRefreshing()
            let banner = NotificationBanner(title: "error", subtitle: error.localizedDescription, style: .danger)
            banner.show()
            
        }).disposed(by: disposeBag)
    }
    
    func requestData(){
        viewModel.input.fetchEvents.acceptAction()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsTableViewCell
        let event = events[indexPath.row]
        cell.setModel(event)
        cell.buttonClick = {[weak self] isFavorite in
            self?.viewModel.input.setEventFavorite.accept((id: event.id, isFavorite: !isFavorite))
        }
        
        return cell
    }

}

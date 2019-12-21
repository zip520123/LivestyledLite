//
//  EventsTableViewCell.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
class EventsTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    var notificationBag = DisposeBag()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonClick: ((Bool)->())?
    var isFavorite = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitle("Favorite", for: .normal)
        profileImageView.layer.cornerRadius = 32
        profileImageView.clipsToBounds = true
        button.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {return}
            self.buttonClick?(self.isFavorite)
        }.disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setModel(_ event: LSEvent){
        if let url = URL(string: event.image ?? "") {
            profileImageView.kf.setImage(with: url, options: [.transition(.fade(0.2)),
                                                              .cacheOriginalImage,
                                                              ] )
        }
        
        titleLabel.text = event.title ?? ""
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE hh:mm"
        dateLabel.text = dateFormater.string(from: event.startDate)
        
        let db = (UIApplication.shared.delegate as! AppDelegate).db
        isFavorite = db.readEventFavorite(eventId: event.id)
        if isFavorite {
            button.setTitle("Unfavorite", for: .normal)
        } else {
            button.setTitle("Favorite", for: .normal)
        }
        
        notificationBag = DisposeBag()
        NotificationCenter.default.rx.notification(.didChangeEventState)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (notification) in
                guard let `self` = self, let result = notification.object as? setEventFavoriteResult else {return}
                if (result.eventId == event.id) {
                    if result.isFavorite {
                        self.button.setTitle("Unfavorite", for: .normal)
                    } else {
                        self.button.setTitle("Favorite", for: .normal)
                    }
                    
                }
            }).disposed(by: notificationBag)
        
    }
    
}

//
//  EventsTableViewCell.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/17.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import UIKit
import Kingfisher
class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitle("Favorite", for: .normal)
        profileImageView.layer.cornerRadius = 32
        profileImageView.clipsToBounds = true
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
        
        
    }
}

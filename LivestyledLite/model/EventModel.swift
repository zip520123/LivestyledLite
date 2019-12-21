//
//  Model.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation

struct LSEvent : Decodable {
    let id : String
    let title : String?
    let image : String?
    let startDate : Date
}

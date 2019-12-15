//
//  LSDecoder.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation
class LSDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .secondsSince1970
    }
}

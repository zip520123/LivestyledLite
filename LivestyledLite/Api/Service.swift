//
//  Service.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/16.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
struct Service : ServiceType {
    var testString : String =
        """
    [
    {
        "id": "5d4aab8ba707c58f2522ddd7",
        "title": "Henson Gilmore",
        "image": "https://s3-eu-west-1.amazonaws.com/bstage/plans/D7L4RQ3XAYNCPW65KB8S.jpg",
        "startDate": 1598722841
    },
    {
    "id": "5d4aab8b2ce888bcf522979d",
    "title": "Vicky Gaines",
    "image": "https://s3-eu-west-1.amazonaws.com/bstage/plans/D7L4RQ3XAYNCPW65KB8S.jpg",
    "startDate": 1667302508
    },]
"""
    func requestEvent(page: Int) -> Observable<[Event]> {
        let data = testString.data(using: .utf8)!
        let model = try! LSDecoder().decode([Event].self, from: data)
        return Observable.just(model)
    }
    
    
}

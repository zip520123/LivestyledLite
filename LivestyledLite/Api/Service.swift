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
    var testString : String = ""
    func requestEvent(page: Int) -> Observable<[Event]> {
        let data = testString.data(using: .utf8)!
        let model = try! LSDecoder().decode([Event].self, from: data)
        return Observable.just(model)
    }
    
    
}

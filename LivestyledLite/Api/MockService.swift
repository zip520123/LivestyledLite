//
//  MockService.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


struct MockService: ServiceType {
    var testString : String = ""
    func requestEvent(page: Int) -> Observable<[LSEvent]> {
        let data = testString.data(using: .utf8)!
        let model = try! LSDecoder().decode([LSEvent].self, from: data)
        return Observable.just(model)
    }
    
    
}

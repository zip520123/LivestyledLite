//
//  ServiceType.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//
import class RxSwift.Observable
import Foundation


protocol ServiceType {
    func requestEvent(page: Int) -> Observable<[LSEvent]>
}

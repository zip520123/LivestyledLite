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

    func requestEvent(page: Int) -> Observable<[Event]> {
//        http://my-json-server.typicode.com/livestyled/mock-api/events?_page=1
        var urlComponent = URLComponents()
        urlComponent.scheme = "http"
        urlComponent.host = "my-json-server.typicode.com"
        urlComponent.path = "/livestyled/mock-api/events"
        let queryItemToken = URLQueryItem(name: "_page", value: "\(page)")
        urlComponent.queryItems = [queryItemToken]
        let request = URLRequest(url: urlComponent.url!)
        
        return URLSession.shared
            .rx.response(request: request)
            .retry(3)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map({ (response, data) -> [Event] in
                if let model = try? LSDecoder().decode([Event].self, from: data) {
                    return model
                }
                return []
            })

    }
    
}

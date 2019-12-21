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

    func requestEvent(page: Int) -> Observable<[LSEvent]> {
//        http://my-json-server.typicode.com/livestyled/mock-api/events?_page=1
        var urlComponent = URLComponents()
        urlComponent.scheme = "http"
        urlComponent.host = "my-json-server.typicode.com"
        urlComponent.path = "/livestyled/mock-api/events"
        let queryItemToken = URLQueryItem(name: "_page", value: "\(page)")
        urlComponent.queryItems = [queryItemToken]
        let request = URLRequest(url: urlComponent.url!)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var catchedModel = [LSEvent]()
        if let cachedResponse = configuration.urlCache?.cachedResponse(for: request) {
            if let model = try? LSDecoder().decode([LSEvent].self, from: cachedResponse.data) {
                catchedModel = model
            }
        }
        
        
        return session
            .rx.response(request: request)
            .retry(3)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map({ (response, data) -> [LSEvent] in
                let cachedResponse = CachedURLResponse(response: response, data: data)
                configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
                if let model = try? LSDecoder().decode([LSEvent].self, from: data) {
                    return model
                }
                return []
            }).catchErrorJustReturn(catchedModel)
        

    }
    
}

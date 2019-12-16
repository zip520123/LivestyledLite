//
//  EventViewModel.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventViewModel {
    let disposeBag = DisposeBag()
    let input: EventViewModelInput
    let output: EventViewModelOutput
    
    // MARK: - Inputs
    struct EventViewModelInput {
        let fetchEvents: PublishRelay<Void>
        
    }
    
    // MARK: - Outputs
    struct EventViewModelOutput {
        let eventsResult: Driver<[Event]>
    }
    
    init(service: ServiceType = Service()){//DI
        
        let currentPage = BehaviorRelay(value: 1)
        let fetchEvents = PublishRelay<Void>()
        let eventsResponse = fetchEvents.flatMapFirst {
            service.requestEvent(page: currentPage.value)
        }.share()
        
        let eventResult =
            eventsResponse
                .do(onNext: { list in
                    currentPage.nextPage()
                    
                }).asDriverOnErrorJustCompleted()
        
        input = EventViewModelInput(fetchEvents: fetchEvents)
        output = EventViewModelOutput(eventsResult: eventResult)
    }
    
}

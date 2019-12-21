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
        let fetchNextPageEvents: PublishRelay<Void>
        let resetLoadingStep: PublishRelay<Void>
        let setEventFavorite: PublishRelay<(id: String, isFavorite: Bool)>
    }
    
    // MARK: - Outputs
    struct EventViewModelOutput {
        let eventsResult: Driver<[LSEvent]>
        let errorOutput: Driver<Error>
    }
    
    init(service: ServiceType = Service(), db: DB = (UIApplication.shared.delegate as! AppDelegate).db ){//DI
        
        let currentPage = BehaviorRelay(value: 1)
        let fetchEvents = PublishRelay<Void>()
        let fetchNextPageEvents = PublishRelay<Void>()
        let shouldBatchMore = BehaviorRelay<Bool>(value: true)
        let resetLoadingStep = PublishRelay<Void>()
        let setEventFavorite = PublishRelay<(id: String, isFavorite: Bool)>()
        
        resetLoadingStep.subscribe(onNext: { (_) in
            currentPage.reset()
            shouldBatchMore.accept(true)
            fetchEvents.acceptAction()
        }).disposed(by: disposeBag)
        
        let eventsResponse = fetchEvents.withLatestFrom(shouldBatchMore)
            .filter { $0 == true }.withLatestFrom(currentPage).flatMapFirst { page in
            service.requestEvent(page: page).materialize()
        }.share()
        
        let dataResult = eventsResponse.elements()
            .do(onNext: { list in
                currentPage.nextPage()
                if list.isEmpty {
                    shouldBatchMore.accept(false)
                }
            }).asDriverOnErrorJustIgnored()
        
        //if request fail, return fake data
        
        let eventResult = Driver.merge(dataResult, eventsResponse.errors().map( { (error) in
            let event = LSEvent(id:"", title:"error", image: nil, startDate: Date())
            
           return [event]
        }).asDriverOnErrorJustIgnored())
        
        fetchNextPageEvents
            .bind(to: fetchEvents)
            .disposed(by: disposeBag)
        
        
        setEventFavorite.subscribe(onNext: { (id, isFavorite) in
            try? db.setEventFavorite(id, isFavorite: isFavorite)
        }).disposed(by: disposeBag)
        
        let errorOutput = eventsResponse.errors().asDriverOnErrorJustCompleted()
        
        input = EventViewModelInput(fetchEvents: fetchEvents, fetchNextPageEvents: fetchNextPageEvents, resetLoadingStep: resetLoadingStep, setEventFavorite: setEventFavorite)
        output = EventViewModelOutput(eventsResult: eventResult, errorOutput: errorOutput)
    }
    
}

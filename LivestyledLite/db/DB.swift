//
//  DB.swift
//  LivestyledLite
//
//  Created by zip520123 on 2019/12/21.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import Foundation
protocol DB {
    func setEventFavorite(_ eventId: String, isFavorite: Bool) throws
    func readEventFavorite(eventId: String) -> Bool
}

struct setEventFavoriteResult {
    let eventId: String
    let isFavorite: Bool
}

struct UserDefaultsDB : DB {
    func setEventFavorite(_ eventId: String, isFavorite: Bool) throws {
        UserDefaults.standard.set(isFavorite, forKey: eventId)
        
        NotificationCenter.default.post(name: .didChangeEventState, object: setEventFavoriteResult(eventId: eventId, isFavorite: isFavorite))
    }
    func readEventFavorite(eventId: String) -> Bool {
        if let eventId = UserDefaults.standard.value(forKey: eventId) as? Bool {
            return eventId
        }
        return false

    }

}

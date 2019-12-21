//
//  LivestyledLiteTests.swift
//  LivestyledLiteTests
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import LivestyledLite

class LivestyledLiteTests: XCTestCase {
    let disposeBag = DisposeBag()
    let db = (UIApplication.shared.delegate as! AppDelegate).db
    
    override func setUp() {
        super.setUp()
        
        //remove all keys in userDefault
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
    }
    
    func testEventModelDecode() throws {
        let data = try readString(from: "eventModels.json").data(using: .utf8)!
        
        let model = try! LSDecoder().decode([LSEvent].self, from: data)

        XCTAssert(model.count == 10)
        XCTAssert(model[0].id == "5d4aab8ba707c58f2522ddd7")
        XCTAssert(model[0].title == "Henson Gilmore")
        XCTAssert(model[0].image == "https://s3-eu-west-1.amazonaws.com/bstage/plans/D7L4RQ3XAYNCPW65KB8S.jpg")
        XCTAssert(model[0].startDate == Date(timeIntervalSince1970: 1598722841))
        
    }
    
    func testNetworkService() throws {
        let service : ServiceType = try mockService(with: "eventModels.json")
        
        let expect = expectation(description: "test service")
        let viewModel = EventViewModel(service: service)
        
        viewModel.output.eventsResult.drive(onNext: { model in
            XCTAssert(model.count == 10)
            XCTAssert(model[0].id == "5d4aab8ba707c58f2522ddd7")
            XCTAssert(model[0].title == "Henson Gilmore")
            XCTAssert(model[0].image == "https://s3-eu-west-1.amazonaws.com/bstage/plans/D7L4RQ3XAYNCPW65KB8S.jpg")
            XCTAssert(model[0].startDate == Date(timeIntervalSince1970: 1598722841))
            expect.fulfill()
        }).disposed(by: disposeBag)
        

        viewModel.input.fetchEvents.acceptAction()
        
        wait(for: [expect], timeout: 0.1)
        
    }
    
    func testSetEventFavorite() throws {
        
        let viewModel = EventViewModel(db: db)
        let testEvent = LSEvent(id: "testEvent", title: "testEvent", image: nil, startDate: Date())
        XCTAssert( db.readEventFavorite(eventId: testEvent.id) == false)
        viewModel.input.setEventFavorite.accept((testEvent.id, isFavorite: true))
        XCTAssert( db.readEventFavorite(eventId: testEvent.id) == true)
        
    }
    
    func testSetEventUnfavorite() throws {

        let testUnfavoriteEvent = LSEvent(id: "testEventUnfavorite", title: "testEventUnfavorite", image: nil, startDate: Date())
        let viewModel = EventViewModel(db: db)
        viewModel.input.setEventFavorite.accept((testUnfavoriteEvent.id, isFavorite: true))
        XCTAssert( db.readEventFavorite(eventId: testUnfavoriteEvent.id) == true)
        
        viewModel.input.setEventFavorite.accept((testUnfavoriteEvent.id, isFavorite: false))
        XCTAssert( db.readEventFavorite(eventId: testUnfavoriteEvent.id) == false)
        
    }
    
    func testUnknowEventFavorite() throws {
        let db = UserDefaultsDB()
        XCTAssert( db.readEventFavorite(eventId: "unknowEvent") == false)
        
    }
    
    
}
extension XCTestCase {
    func mockService(with file: String) throws -> MockService {
        return MockService(testString: try readString(from: file))
    }
    func readString(from file: String) throws -> String {
        //Json fails reading multiline string. Instead read json from file https://bugs.swift.org/browse/SR-6457
        let bundle = Bundle(for: type(of: self))
        let path = bundle.url(forResource: file, withExtension: nil)!
        let data = try Data(contentsOf: path)
        return String(data: data, encoding: .utf8)!
    }
}

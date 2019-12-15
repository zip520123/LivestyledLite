//
//  LivestyledLiteTests.swift
//  LivestyledLiteTests
//
//  Created by zip520123 on 2019/12/15.
//  Copyright © 2019年 zip520123. All rights reserved.
//

import XCTest
@testable import LivestyledLite

class LivestyledLiteTests: XCTestCase {
    
    func testEventModelDecode() throws {
        let data = try readString(from: "eventModels.json").data(using: .utf8)!
        
        let model = try! LSDecoder().decode([Event].self, from: data)

        XCTAssert(model.count == 10)
        XCTAssert(model[0].id == "5d4aab8ba707c58f2522ddd7")
        XCTAssert(model[0].title == "Henson Gilmore")
        XCTAssert(model[0].title == "https://s3-eu-west-1.amazonaws.com/bstage/plans/D7L4RQ3XAYNCPW65KB8S.jpg")
        XCTAssert(model[0].startDate == Date(timeIntervalSince1970: 1598722841))
        
    }
    
}
extension XCTestCase {

    func readString(from file: String) throws -> String {
        //Json fails reading multiline string. Instead read json from file https://bugs.swift.org/browse/SR-6457
        let bundle = Bundle(for: type(of: self))
        let path = bundle.url(forResource: file, withExtension: nil)!
        let data = try Data(contentsOf: path)
        return String(data: data, encoding: .utf8)!
    }
}

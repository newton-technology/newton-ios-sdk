//
//  File.swift
//  
//
//  Created by Mihail Kuznetsov on 12.01.2022.
//

import Foundation
import XCTest

@testable import NewtonAuth

class TimestampUtilsTests: XCTestCase {
    
    func test_getExpirationTimeInSeconds_shouldBeValid() {
        let timeInSecs1 = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: nil, httpHeaders: nil)
        XCTAssertNil(timeInSecs1)
        
        let timestamp: Double = 1641992857
        let timeInSecs2 = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: timestamp, httpHeaders: nil)
        XCTAssertNotNil(timeInSecs2)
        XCTAssertEqual(timestamp, timeInSecs2)
        
        let dateString = "Wed, 12 Jan 2022 13:07:37 GMT"
        let headers: [AnyHashable: Any] = ["Date": dateString]
        let timeInSecs3 = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: timestamp, httpHeaders: headers)
        XCTAssertNotNil(timeInSecs3)
        XCTAssertNotEqual(timestamp, timeInSecs3)
    }

    func test_decodeDate_shouldBeValid() throws {
        let dateString = "Wed, 12 Jan 2022 13:07:37 GMT"
        
        let dateDecoded = TimestampUtils.getDateFromString(dateString: dateString)
        
        XCTAssertNotNil(dateDecoded)
    }
    
    func test_getTimestampInLocalTime_shouldBeValid() throws {
        
        let dateString = "Wed, 12 Jan 2022 13:07:37 GMT"
        let timestamp: Double = 1641992857
        
        let headers: [AnyHashable: Any] = ["Date": dateString]
        
        let timestampInLocalTime = TimestampUtils.getTimestampInLocalTime(timestamp: timestamp, headers: headers)
        XCTAssertNotEqual(timestamp, timestampInLocalTime)
    }
    
}

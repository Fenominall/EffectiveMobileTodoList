//
//  FeedTasksMapperTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/4/24.
//

import Foundation
import EffectiveMobileTodoList
import XCTest

class FeedTasksMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        
        let samples = [199, 201, 300, 400, 404, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedTasksMapper
                    .map(json,
                         from: HTTPURLResponse(statusCode: code)))
        }
    }
}

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
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalidJSON".utf8)
        
        XCTAssertThrowsError(
            try FeedTasksMapper
                .map(invalidJSON,
                     from: HTTPURLResponse(statusCode: 200)))
    }
    
    // MARK: Checking Success Courses for VALID JSON
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyList() throws {
        let emptyJSON = makeItemsJSON([])
        
        let result =
        try FeedTasksMapper
            .map(emptyJSON,
                 from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliverFeedItemsOn200HTTPResponseWithValidJSONItems() throws {
        let item1 =  makeTask(
            id: 1,
            name: "Author1",
            description: "Description1",
            dateCreated: ISO8601DateFormatter().date(from: "2024-07-06T10:38:44Z")!,
            status: false
        )
        
        let item2 = makeTask(
            id: 2,
            name: "Author2",
            description: "Description1",
            dateCreated: ISO8601DateFormatter().date(from: "2024-07-06T10:39:44Z")!,
            status: true
        )
        
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try FeedTasksMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
}

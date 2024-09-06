//
//  CoreDataFeedStoreTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/5/24.
//

import Foundation
import XCTest
import EffectiveMobileTodoList

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .success(.none))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        
        let feed = uniqueTodoTaskFeed().local
        
        _ = insert(feed, to: sut)
        
        expect(sut, toRetrieve: .success(feed))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        let feed = uniqueTodoTaskFeed().local
        
        _ = insert(feed, to: sut, checkError: true)
        
        expect(sut, toRetrieveTwice: .success(feed))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let feed = uniqueTodoTaskFeed().local
        
        let insertionError = insert(feed, to: sut, checkError: true)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        let insertionError = insert([], to: sut, checkError: true)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let insertionError = insert([], to: sut, checkError: true)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func insert(_ feed: [LocalTodoTask], to sut: FeedStore, completion: @escaping (Error?) -> Void) {
        let insertExp = expectation(description: "Wait for insert completion")
        
        sut.insert(feed) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    func expect(
        _ sut: FeedStore,
        toRetrieve expectedResult: Result<[LocalTodoTask]?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                break
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func expect(
        _ sut: FeedStore,
        toRetrieveTwice expectedResult: Result<[LocalTodoTask]?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line) {
            expect(sut, toRetrieve: expectedResult, file: file, line: line)
            expect(sut, toRetrieve: expectedResult, file: file, line: line)
        }
}

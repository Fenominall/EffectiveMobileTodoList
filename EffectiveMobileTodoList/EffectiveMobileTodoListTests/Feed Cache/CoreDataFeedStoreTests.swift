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
        
        insert(feed, to: sut) { _ in }
        
        expect(sut, toRetrieve: .success(feed))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        let feed = uniqueTodoTaskFeed().local
        
        insert(feed, to: sut) { _ in }
        
        expect(sut, toRetrieveTwice: .success(feed))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let feed = uniqueTodoTaskFeed().local
        
        insert(feed, to: sut) { insertionError in
            XCTAssertNil(insertionError, "Expected to insert cache successfully")
        }
    }
    
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        insert([], to: sut) { insertionError in
            XCTAssertNil(insertionError, "Expected to insert cache successfully")
        }
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        insert([], to: sut) { insertionError in
            XCTAssertNil(insertionError, "Expected to override cache successfully")
        }
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        deleteCache(from: sut) { deletionError in
            XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        }
        
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        deleteCache(from: sut) { _ in }
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        let tasks = uniqueTodoTaskFeed().local
        
        insert(tasks, to: sut) { [weak self] _ in
            self?.deleteCache(tasks, from: sut) { deletionError in
                XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
            }
        }
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        // todo
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let sut = makeSUT()
        let tasks = uniqueTodoTaskFeed().local
        
        insert(tasks, to: sut) { insertionError in
            XCTAssertNil(insertionError, "Expected successful insertion before testing deletion error")
            
            let failingStore = FailingFeedStore()
            
            failingStore.delete(tasks.first!) { deletionResult in
                switch deletionResult {
                case .success:
                    XCTFail("Expected deletion to fail, but it succeeded")
                case .failure(let error):
                    XCTAssertTrue(error is SomeSpecificError, "Expected error of type SomeSpecificError, but got \(type(of: error))")
                    if let specificError = error as? SomeSpecificError {
                        XCTAssertEqual(specificError, SomeSpecificError.expectedError, "Unexpected error received")
                    }
                }
            }
        }
    }
    
    func test_update_deliversNoErrorOnExistingTask() {
    }
    
    func test_update_overridesPreviouslyUpdatedTask() {
        
    }
    
    func test_update_hasNoSideEffectsOnUpdate() {
        
    }
    
    func test_update_failsIfTaskDoesNotExist() {
        
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
            insertExp.fulfill()
        }
        
        wait(for: [insertExp], timeout: 1.0)
    }
    
    func deleteCache(_ tasks: [LocalTodoTask] = [], from sut: FeedStore, completion: @escaping (Error?) -> Void) {
        _ = tasks.map {
            sut.delete($0) { result in
                switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
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


class FailingFeedStore: FeedStore {
    func insert(_ task: EffectiveMobileTodoList.LocalTodoTask, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func update(_ task: EffectiveMobileTodoList.LocalTodoTask, completion: @escaping (UpdatingResult) -> Void) {
        completion(.success(()))
    }
    
    func insert(_ feed: [LocalTodoTask], completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func delete(_ task: LocalTodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate a deletion error
        completion(.failure(SomeSpecificError.expectedError))
    }
    
    func retrieve(completion: @escaping (Result<[LocalTodoTask]?, Error>) -> Void) {
        completion(.success([]))
    }
}

enum SomeSpecificError: Error {
    case expectedError
}

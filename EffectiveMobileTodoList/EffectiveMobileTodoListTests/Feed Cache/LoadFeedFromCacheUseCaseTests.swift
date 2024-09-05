//
//  LoadFeedFromCacheUseCaseTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/4/24.
//

import Foundation
import EffectiveMobileTodoList
import XCTest

public final class LocalFeedLoader: TasksLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(
        store: FeedStore,
        currentDate: @escaping () -> Date
    ) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (TasksLoader.Result) -> Void) {
    }
}

public struct LocalTodoTask: Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public let status: Bool
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        status: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.status = status
    }
}

public typealias CachedFeed  = (feed: [LocalTodoTask], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    typealias UpdatingResult = Swift.Result<Void, Error>
    typealias UpdatingCompletion = (UpdatingResult) -> Void
    
    func delete(_ tasks: [LocalTodoTask], completion: @escaping DeletionCompletion)
    func insert(_ tasks: [LocalTodoTask], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
    func update(_ task: LocalTodoTask, completion: @escaping (UpdatingResult) -> Void)
}


final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line)
    -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func excpect(
        _ sut: LocalFeedLoader,
        toCompleteWith expectedResult: Result<[TodoTask], Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            sut.load { receivedResult in
                switch (receivedResult, expectedResult) {
                case let (.success(receivedImages), .success(expectedImages)):
                    XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
                case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
                }
            }
            action()
        }
}

//
//  DeleteFeedUseCaseTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/5/24.
//

import Foundation
import XCTest
import EffectiveMobileTodoList

final class DeleteFeedUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_delete_doesNotDeleteCacheOnDeletionError() {
        let (sut,store) = makeSUT()
        let deletionError = anyNSError()
        let task = uniqueTodoTask()
        
        sut.delete(selected: task) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(
            store.receivedMessages,
            [.deleteCachedFeed(convertToUniqueLocalTodoTask(with: task))]
        )
    }
    
    func test_delete_successfullyDeletesCache() {
        let timestamp = Date()
        let task = uniqueTodoTask()
        let (sut,store) = makeSUT(currentDate: { timestamp })
        
        sut.delete(selected: task) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(
            store.receivedMessages,
            [.deleteCachedFeed(convertToUniqueLocalTodoTask(with: task))]
        )
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line)
    -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func excpect(
        _ sut: LocalFeedLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            sut.delete(selected: uniqueTodoTask()) { result in
                switch result {
                case .success:
                    XCTAssertNil(expectedError, "Expected error \(String(describing: expectedError)) but got success instead", file: file, line: line)
                case .failure(let error as NSError):
                    XCTAssertEqual(error, expectedError, file: file, line: line)
                default:
                    XCTFail("Unexpected result \(result)", file: file, line: line)
                }
            }
            action()
        }
}

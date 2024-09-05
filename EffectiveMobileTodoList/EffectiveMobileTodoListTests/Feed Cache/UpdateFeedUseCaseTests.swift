//
//  UpdateFeedUseCaseTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/5/24.
//

import Foundation
import XCTest
import EffectiveMobileTodoList

final class UpdateFeedUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_update_failsOnUpdatingError() {
        let (sut,store) = makeSUT()
        let insertionError = anyNSError()
        
        excpect(sut, toCompleteWithError: insertionError) {
            store.completeUpdate(with: insertionError)
        }
    }
    
    func test_update_succeedsOnSuccessfulCacheUpdating() {
        let (sut,store) = makeSUT()
        
        excpect(sut, toCompleteWithError: nil) {
            store.completeUpdateSuccessfully()
        }
    }
    
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
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            sut.update(selected: uniqueTodoTask()) { result in
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

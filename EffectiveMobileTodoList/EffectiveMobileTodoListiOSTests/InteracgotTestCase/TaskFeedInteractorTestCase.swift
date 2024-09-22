//
//  TaskFeedInteractorTestCase.swift
//  EffectiveMobileTodoListiOSTests
//
//  Created by Fenominall on 9/22/24.
//

import XCTest
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class TasksFeedInteractorTests: XCTestCase {
    
    func test_loadTasks_callsLoaderAndPassesTasksToPresenterOnSuccess() {
        let (sut, loaderSpy) = makeSUT()
        
        sut.loadTasks()
        loaderSpy.completeLoading(with: [uniqueTodoTask()])
        
        
    }
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) ->  (interactor: TasksFeedInteractor, loader: MockLoaderSpy) {
        let loaderSpy = MockLoaderSpy()
        let presenterSpy = MockPresenterSpy()
        
        let interactor = TasksFeedInteractor(loader: loaderSpy, remover: loaderSpy, taskSaver: loaderSpy)
        interactor.presenter = presenterSpy
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        trackForMemoryLeaks(presenterSpy, file: file, line: line)
        trackForMemoryLeaks(interactor, file: file, line: line)
        return (interactor, loaderSpy)
    }
    
    private func excpect(
        _ sut: MockLoaderSpy,
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
    
    private func excpect(
        _ sut: MockLoaderSpy,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            sut.save(uniqueTodoTaskFeed().models) { result in
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
    
    private func excpectDelete(
        _ sut: MockLoaderSpy,
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
    
    private func excpect(
        _ sut: LocalFeedLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            sut.update(uniqueTodoTask()) { result in
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

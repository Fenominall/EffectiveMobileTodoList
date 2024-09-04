//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/4/24.
//

import XCTest
import EffectiveMobileTodoList

public final class RemoteFeedLoader: TasksLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias LoadResult = TasksLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success: break
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = anyNSError()
            client.complete(with: clientError)
        })
    }
    
    
    // MARK: - Helpers
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteFeedLoader,
        toCompleteWith expectedResult: RemoteFeedLoader.LoadResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (
                .success(receivedItems),
                .success(expectedItems)
            ):
                XCTAssertEqual(
                    receivedItems,
                    expectedItems,
                    file: file,
                    line: line
                )
                
            case let (
                .failure(receivedError as RemoteFeedLoader.Error),
                .failure(expectedError as RemoteFeedLoader.Error)
            ):
                XCTAssertEqual(
                    receivedError,
                    expectedError,
                    file: file,
                    line: line
                )
                
            default:
                XCTFail(
                    "Expected result \(expectedResult) got \(receivedResult) instead",
                    file: file,
                    line: line
                )
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.LoadResult {
        return .failure(error)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        private(set) var cancelledURLs = [URL]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
}



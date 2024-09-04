//
//  RemoteFeedLoader.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/4/24.
//

import Foundation

public final class RemoteFeedLoader: TasksLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
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
            do {
                switch result {
                case let .success((data, response)):
                    let todos = try FeedTasksMapper.map(data, from: response)
                    completion(.success(todos))
                case .failure:
                    completion(.failure(Error.connectivity))
                }
            } catch {
                completion(.failure(Error.invalidData))
            }
        }
    }
}

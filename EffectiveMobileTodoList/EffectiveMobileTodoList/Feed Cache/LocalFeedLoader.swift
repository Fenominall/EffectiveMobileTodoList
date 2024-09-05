//
//  LocalFeedLoader.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(
        store: FeedStore,
        currentDate: @escaping () -> Date
    ) {
        self.store = store
        self.currentDate = currentDate
    }
    
    // MARK: - Helpers
    private typealias Completion<T> = (T) -> Void
    
    private func execute<T>(_ completion: Completion<T>?, result: T) {
        guard completion != nil else { return }
        completion?(result)
    }
}

// Load
extension LocalFeedLoader: TasksLoader {
    private struct EmptyCacheError: Error {}
    
    public func load(completion: @escaping (TasksLoader.Result) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case let .success(.some(cachedFeed)):
                let feed = cachedFeed.feed.toModels()
                completion(.success(feed))
            case let .failure(error):
                completion(.failure(error))
            case .success(.none):
                completion(.failure(EmptyCacheError()))
            }
        }
    }
}

// Save
extension LocalFeedLoader: FeedCache {
    public func save(_ feed: [TodoTask], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocals(), timestamp: currentDate()) { [weak self] insertionError in
            self?.execute(completion, result: insertionError)
        }
    }
}

private extension Array where Element == LocalTodoTask {
    func toModels() -> [TodoTask] {
        return map {
            TodoTask(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                status: $0.status
            )
        }
    }
}

private extension Array where Element == TodoTask {
    func toLocals() -> [LocalTodoTask] {
        return map {
            LocalTodoTask(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                status: $0.status
            )
        }
    }
}


//
//  LocalFeedLoader.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    
    public init(store: FeedStore) {
        self.store = store
    }
    
    // MARK: Helpers
    private typealias Completion<T> = (T) -> Void
    
    private func execute<T>(_ completion: Completion<T>?, result: T) {
        guard completion != nil else { return }
        completion?(result)
    }
}

// MARK: - Load
extension LocalFeedLoader: TasksLoader {
    private struct EmptyCacheError: Error {}
    
    public func load(completion: @escaping (TasksLoader.Result) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case let .success(.some(cachedFeed)):
                let feed = cachedFeed.toModels()
                completion(.success(feed))
            case let .failure(error):
                completion(.failure(error))
            case .success(.none):
                completion(.failure(EmptyCacheError()))
            }
        }
    }
}

// MARK: - Save Tasks
extension LocalFeedLoader: TasksFeedCache {
    public func save(_ feed: [TodoTask], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocals()) { [weak self] insertionError in
            self?.execute(completion, result: insertionError)
        }
    }
}

extension LocalFeedLoader: TaskSaver {
    public func save(_ task: TodoTask, completion: @escaping (SaveResult) -> Void) {
        store.insert(createLocalTodTask(with: task)) { [weak self] insertionError in
            self?.execute(completion, result: insertionError)
        }
    }
}

// MARK: - Update
extension LocalFeedLoader {
    public typealias Result = Swift.Result<Void, Error>
    
    public func update(
        _ task: TodoTask,
        completion: @escaping (Result) -> Void
    ) {
        store.update(createLocalTodTask(with: task)) { [weak self] updatingError in
            self?.execute(completion, result: updatingError)
        }
    }
    
    private func createLocalTodTask(with task: TodoTask) -> LocalTodoTask {
        LocalTodoTask(
            id: task.id,
            name: task.name,
            description: task.description,
            dateCreated: task.dateCreated,
            status: task.status,
            startTime: task.startTime,
            endTime: task.endTime
        )
    }
}

// MARK: - Delete
extension LocalFeedLoader: TasksRemover {
    public typealias DeletionResult = Swift.Result<Void, Error>
    
    public func delete(
        selected task: TodoTask,
        completion: @escaping (DeletionResult) -> Void
    ) {
        store.delete(createLocalTodTask(with: task)) { [weak self] deletionError in
            self?.execute(completion, result: deletionError)
        }
    }
}

// MARK: - Converting Helpers
private extension Array where Element == LocalTodoTask {
    func toModels() -> [TodoTask] {
        return map {
            TodoTask(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                status: $0.status,
                startTime: $0.startTime,
                endTime: $0.endTime
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
                status: $0.status,
                startTime: $0.startTime,
                endTime: $0.endTime
            )
        }
    }
}

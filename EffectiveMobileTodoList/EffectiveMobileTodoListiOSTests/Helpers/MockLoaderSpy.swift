//
//  MockLoaderSpy.swift
//  EffectiveMobileTodoListiOSTests
//
//  Created by Fenominall on 9/22/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class MockLoaderSpy: TasksLoader {
    enum ReceivedMessages: Equatable {
        case deleteCachedFeed(TodoTask)
        case insert([TodoTask])
        case insert(task: TodoTask)
        case retrieve
        case update(TodoTask)
    }
    private(set) var receivedMessages = [ReceivedMessages]()
    
    private var deletionResult: TasksRemover.DeletionResult?
    private var insertionResult: TaskSaver.SaveResult?
    private var feedInsertionResult: TasksFeedCache.SaveResult?
    private var retrievalResult: TasksLoader.Result?
    private var updatingResult: TaskSaver.SaveResult?
        
    
    // Loading
    func load(completion: @escaping (TasksLoader.Result) -> Void) {
        receivedMessages.append(.retrieve)
        if let result = retrievalResult {
            completion(result)
        }
    }
    
    func completeLoading(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeLoadingWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success([])
    }
    
    func completeLoading(
        with feed: [TodoTask],
        at index: Int = 0) {
            retrievalResult = .success(feed)
        }
}

// Saving
extension MockLoaderSpy: TaskSaver {
    func save(_ task: EffectiveMobileTodoList.TodoTask, completion: @escaping (SaveResult) -> Void) {
        receivedMessages.append(.insert(task: task))
        if let result = insertionResult {
            completion(result)
        }
    }
    
    func completeTaskInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeTaskInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func update(_ task: EffectiveMobileTodoList.TodoTask, completion: @escaping (SaveResult) -> Void) {
        receivedMessages.append(.update(task))
        if let result = updatingResult {
            completion(result)
        }
    }
    
    func completeUpdating(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeUpdatingSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}

// Save Feed
extension MockLoaderSpy: TasksFeedCache {
    func save(_ feed: [TodoTask], completion: @escaping (SaveResult) -> Void) {
        receivedMessages.append(.insert(feed))
        if let result = feedInsertionResult {
            completion(result)
        }
    }
    
    func completeFeedInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeFeedInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}

// Delete
extension MockLoaderSpy: TasksRemover {
    func delete(selected task: EffectiveMobileTodoList.TodoTask, completion: @escaping (DeletionResult) -> Void) {
        receivedMessages.append(.deleteCachedFeed(task))
        if let result = deletionResult {
            completion(result)
        }
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }
}

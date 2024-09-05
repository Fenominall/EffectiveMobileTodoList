//
//  FeedStoreSpy.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/4/24.
//

import Foundation
import EffectiveMobileTodoList

class FeedStoreSpy: FeedStore {
    enum ReceivedMessages: Equatable {
        case deleteCachedFeed([LocalTodoTask])
        case insert([LocalTodoTask], Date)
        case retrieve
        case update(LocalTodoTask)
    }
    private (set) var receivedMessages = [ReceivedMessages]()
    
    private var deletionResult: FeedStore.DeletionResult?
    private var insertionResult: FeedStore.InsertionResult?
    private var retrievalResult: FeedStore.RetrievalResult?
    private var updatingResult: FeedStore.UpdatingResult?
    
    // Deletion
    func delete(
        _ transactions: [LocalTodoTask],
        completion: @escaping FeedStore.DeletionCompletion
    ) {
        receivedMessages.append(.deleteCachedFeed(transactions))
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
    
    // Insertion
    func insert(
        _ tasks: [LocalTodoTask],
        timestamp: Date,
        completion: @escaping FeedStore.InsertionCompletion
    ) {
        receivedMessages.append(.insert(tasks, timestamp))
        if let result = insertionResult {
            completion(result)
        }
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    // Retrieval
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        if let result = retrievalResult {
            completion(result)
        }
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(
        with feed: [LocalTodoTask],
        timestamp: Date,
        at index: Int = 0) {
            retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
        }
    
    // Updating
    func update(
        _ task: LocalTodoTask,
        completion: @escaping FeedStore.UpdatingCompletion
    ) {
        receivedMessages.append(.update(task))
        if let result = updatingResult {
            completion(result)
        }
    }
    
    func completeUpdate(with error: Error, at index: Int = 0) {
        updatingResult = .failure(error)
    }
    
    func completeUpdateSuccessfully(at index: Int = 0) {
        updatingResult = .success(())
    }
    
}


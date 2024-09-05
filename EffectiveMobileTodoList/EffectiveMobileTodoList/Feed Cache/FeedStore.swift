//
//  FeedStore.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

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

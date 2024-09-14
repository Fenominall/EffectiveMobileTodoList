//
//  FeedStore.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[LocalTodoTask]?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    typealias UpdatingResult = Swift.Result<Void, Error>
    typealias UpdatingCompletion = (UpdatingResult) -> Void
    
    func delete(_ task: LocalTodoTask, completion: @escaping DeletionCompletion)
    func insert(_ tasks: [LocalTodoTask], completion: @escaping InsertionCompletion)
    func insert(_ task: LocalTodoTask, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
    func update(_ task: LocalTodoTask, completion: @escaping (UpdatingResult) -> Void)
}

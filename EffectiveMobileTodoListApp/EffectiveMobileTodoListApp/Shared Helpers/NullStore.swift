//
//  NullStore.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

class NullStore: FeedStore {
    func insert(_ task: EffectiveMobileTodoList.LocalTodoTask, completion: (InsertionResult) -> Void) {
        completion(.success(()))
    }
    
    func delete(_ task: EffectiveMobileTodoList.LocalTodoTask, completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ tasks: [EffectiveMobileTodoList.LocalTodoTask], completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
    
    func update(_ task: EffectiveMobileTodoList.LocalTodoTask, completion: @escaping (UpdatingResult) -> Void) {
        completion(.success(()))
    }
}

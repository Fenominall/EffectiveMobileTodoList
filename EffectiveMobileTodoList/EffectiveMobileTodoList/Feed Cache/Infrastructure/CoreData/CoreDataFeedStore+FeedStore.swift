//
//  CoreDataFeedStore+FeedStore.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import CoreData

extension CoreDataFeedStore: FeedStore {
    public func delete(_ tasks: [LocalTodoTask], completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ tasks: [LocalTodoTask], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        
    }
    
    public func update(_ task: LocalTodoTask, completion: @escaping (UpdatingResult) -> Void) {
        
    }
}

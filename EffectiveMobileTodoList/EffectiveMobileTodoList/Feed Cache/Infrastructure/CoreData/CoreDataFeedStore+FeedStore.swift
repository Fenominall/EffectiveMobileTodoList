//
//  CoreDataFeedStore+FeedStore.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import CoreData

extension CoreDataFeedStore: FeedStore {
    public func insert(_ tasks: [LocalTodoTask], completion: @escaping InsertionCompletion) {
        performAsync { context in
            completion(Result {
                try ManagedCache.insertTasks(tasks, in: context)
            })
        }
    }
    
    public func insert(_ task: LocalTodoTask, completion: (InsertionResult) -> Void) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        performAsync { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    return $0.localTodoTasksFeed
                }
            })
        }
    }
    
    public func delete(_ task: LocalTodoTask, completion: @escaping DeletionCompletion) {
        performAsync { context in
            completion(Result {
                try ManagedTodoTask.deleteTask(task, in: context)
            })
        }
    }
    
    public func update(_ task: LocalTodoTask, completion: @escaping (UpdatingResult) -> Void) {
        performAsync { context in
            completion(Result {
                try ManagedCache.updateTask(task, context: context)
            })
        }
    }
}

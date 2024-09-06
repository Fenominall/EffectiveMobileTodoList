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
                let managedCache = try ManagedCache.fetchCache(in: context)
                try managedCache.updateCache(with: tasks, in: context)
                try context.save()
            })
        }
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
                guard let cache = try ManagedCache.find(in: context)?.feed else {
                    throw CacheError.missingManagedObjectContext
                }
                
                guard let managedTask = try ManagedTodoTask.first(with: task, in: context) else {
                    throw CacheError.taskNotFound
                }
                
                let mutableCache = cache.mutableCopy() as! NSMutableOrderedSet
                try ManagedTodoTask.deleteTask(managedTask, in: mutableCache, context)
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

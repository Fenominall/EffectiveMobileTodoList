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
                // Fetch or create the cache
                let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
                
                // Fetch existing task IDs
                let existingTaskIDs = try ManagedTodoTask.fetchExistingTaskIDs(in: context)
                
                // Filter new tasks (skip existing tasks)
                let newTasks = tasks.filter { task in
                    !existingTaskIDs.contains(task.id)
                }
                
                // Insert only new tasks into the cache
                if !newTasks.isEmpty {
                    try managedCache.updateCache(with: newTasks, in: context)
                    try context.save()
                }
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

//
//  ManagedCache+CoreDataProperties.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    @NSManaged public var feed: NSOrderedSet
}

extension ManagedCache {
    var localTodoTasksFeed: [LocalTodoTask] {
        // Ensure cache is not nil and contains valid objects
        guard let cache = feed.array as? [ManagedTodoTask] else {
            return []
        }
        
        return cache.compactMap { $0.local }
    }
    
    static func fetchOrCreateCache(in context: NSManagedObjectContext) throws -> ManagedCache {
        guard let cache = try ManagedCache.find(in: context) else {
            return ManagedCache(context: context)
        }
        return cache
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func insertTasks(_ tasks: [LocalTodoTask], in context: NSManagedObjectContext) throws {
        let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
        
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
    }
    
    func updateCache(with tasks: [LocalTodoTask], in context: NSManagedObjectContext) throws {
        let managedCache = try ManagedCache.fetchOrCreateCache(in: context)

        // Copy existing tasks from the feed
        let existingTasks = feed.mutableCopy() as? NSMutableOrderedSet ?? NSMutableOrderedSet()

        // Create new managed tasks and associate them with the cache
        let newTasks = ManagedTodoTask.createManagedTodoTasks(from: tasks, in: context, cache: managedCache)
        
        // Add new tasks to the existing cache
        existingTasks.addObjects(from: newTasks.array)

        // Update the cache feed
        if let updatedCache = existingTasks.copy() as? NSOrderedSet {
            feed = updatedCache
        } else {
            throw CacheError.unableToCreateMutableCopy
        }
    }

    static func updateTask(_ task: LocalTodoTask, context: NSManagedObjectContext) throws {
        guard let managedTask = try ManagedTodoTask.first(with: task, in: context) else {
            throw CacheError.taskNotFound
        }
        
        guard managedTask.id == task.id else {
            throw CacheError.taskIDMismatch
        }
        
        ManagedTodoTask.update(managedTask, with: task)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}

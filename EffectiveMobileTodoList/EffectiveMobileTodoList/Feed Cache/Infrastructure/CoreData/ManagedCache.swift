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
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func fetchCache(in context: NSManagedObjectContext) throws -> ManagedCache {
        guard let cache = try ManagedCache.find(in: context) else {
            return ManagedCache(context: context)
        }
        return cache
    }
    
    func updateCache(with tasks: [LocalTodoTask], in context: NSManagedObjectContext) throws {
        let existingTransactions = feed.mutableCopy() as? NSMutableOrderedSet ?? NSMutableOrderedSet()
        let newTransactions = ManagedTodoTask.createManagedTodoTasks(from: tasks, in: context)
        existingTransactions.addObjects(from: newTransactions.array)
        
        if let updatedCache = existingTransactions.copy() as? NSOrderedSet {
            feed = updatedCache
        } else {
            throw CacheError.unableToCreateMutableCopy
        }
    }
    
}


extension ManagedCache : Identifiable {
    
}

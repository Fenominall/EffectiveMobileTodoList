//
//  ManagedTodoTask+CoreDataProperties.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//
//

import Foundation
import CoreData

@objc(ManagedTodoTask)
public class ManagedTodoTask: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var descriptionText: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var status: Bool
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var cache: ManagedCache?
}

extension ManagedTodoTask {
    
    var local: LocalTodoTask? {
        return LocalTodoTask(
            id: id,
            name: name,
            description: descriptionText,
            dateCreated: dateCreated,
            status: status
        )
    }
    
    static func first(
        with localTodoTask: LocalTodoTask,
        in context: NSManagedObjectContext
    ) throws -> ManagedTodoTask? {
        let request = NSFetchRequest<ManagedTodoTask>(
            entityName: ManagedTodoTask.entity().name!
        )
        
        let uuidPredicate = NSPredicate(
            format: "id == %@",
            localTodoTask.id as CVarArg
        )
        
        request.predicate = uuidPredicate
        
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    static func fetchExistingTaskIDs(in context: NSManagedObjectContext) throws -> Set<UUID> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedTodoTask.entity().name!)
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["id"]
        
        let results = try context.fetch(request) as? [[String: Any]]
        
        let ids = results?.compactMap { dict in
            // Extract UUID from dictionary using the key "id"
            dict["id"] as? UUID
        }
        
        return Set(ids ?? [])
    }
    
    static func createManagedTodoTasks(
        from localTasks: [LocalTodoTask],
        in context: NSManagedObjectContext,
        cache: ManagedCache
    ) -> NSOrderedSet {
        let tasks = NSOrderedSet(array: localTasks.map { local in
            let managedTask = ManagedTodoTask(context: context)
            managedTask.id = local.id
            managedTask.name = local.name
            managedTask.descriptionText = local.description
            managedTask.dateCreated = local.dateCreated
            managedTask.status = local.status
            managedTask.startTime = local.startTime
            managedTask.endTime = local.endTime
            managedTask.cache = cache
            
            return managedTask
        })
        
        return tasks
    }
    
    static func deleteTask(_ task: LocalTodoTask, in context: NSManagedObjectContext) throws {
        // Ensure the cache exists before proceeding
        guard let cache = try ManagedCache.find(in: context) else {
            throw CacheError.missingManagedObjectContext
        }
        
        // Find the task to delete
        guard let managedTask = try ManagedTodoTask.first(with: task, in: context) else {
            throw CacheError.taskNotFound
        }
        
        // Remove the task from the cache feed
        if let mutableCache = cache.feed.mutableCopy() as? NSMutableOrderedSet {
            mutableCache.remove(managedTask)
            cache.feed = mutableCache as NSOrderedSet
        } else {
            throw CacheError.unableToCreateMutableCopy
        }
        
        // Delete the task from Core Data context
        context.delete(managedTask)
        
        // Save the context
        try context.save()
    }
    
    static func update(_ managedTask: ManagedTodoTask, with task: LocalTodoTask) {
        managedTask.id = task.id
        managedTask.name = task.name
        managedTask.descriptionText = task.description
        managedTask.dateCreated = task.dateCreated
        managedTask.startTime = task.startTime
        managedTask.endTime = task.endTime
        managedTask.status = task.status
    }
}

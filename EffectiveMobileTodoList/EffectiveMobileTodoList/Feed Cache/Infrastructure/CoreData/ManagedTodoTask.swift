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
    @NSManaged public var cache: ManagedCache
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
    
    
    static func createManagedTodoTasks(
        from localTasks: [LocalTodoTask],
        in context: NSManagedObjectContext
    ) -> NSOrderedSet {
        
        let tasks = NSOrderedSet(array: localTasks.map { local in
            let managedTask = ManagedTodoTask(context: context)
            managedTask.id = local.id
            managedTask.name = local.name
            managedTask.descriptionText = local.description
            managedTask.dateCreated = local.dateCreated
            managedTask.status = local.status
            
            return managedTask
        })
        
        return tasks
    }
    
    static func deleteTask(
        _ task: ManagedTodoTask,
        in cache: NSOrderedSet,
        _ context: NSManagedObjectContext) throws {
            
            guard let mutableCache = cache.mutableCopy() as? NSMutableOrderedSet else {
                throw CacheError.unableToCreateMutableCopy
            }
            
            try findAndDelete(task, mutableCache, in: context)
            
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    
    private static func findAndDelete(
        _ task: ManagedTodoTask,
        _ mutableCache: NSMutableOrderedSet,
        in context: NSManagedObjectContext
    ) throws {
        
        mutableCache.remove(task)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    static func update(_ managedTask: ManagedTodoTask, with task: LocalTodoTask) {
        managedTask.id = task.id
        managedTask.name = task.name
        managedTask.descriptionText = task.description
        managedTask.dateCreated = task.dateCreated
        managedTask.status = task.status
    }
}

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

extension ManagedTodoTask : Identifiable {

}

//
//  TaskViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation

public struct TodoTaskViewModel: Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public var isCompleted: Bool
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        isCompleted: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
    }
    
    public var onSaveAddTransaction: ((TodoTaskViewModel) -> Void)?
    public var onSaveUpdateTransaction: ((TodoTaskViewModel) -> Void)?
    
    public static func == (lhs: TodoTaskViewModel, rhs: TodoTaskViewModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.isCompleted == rhs.isCompleted
    }
}

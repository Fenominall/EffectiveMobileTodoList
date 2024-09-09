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
    public let isCompleted: Bool
    
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
}

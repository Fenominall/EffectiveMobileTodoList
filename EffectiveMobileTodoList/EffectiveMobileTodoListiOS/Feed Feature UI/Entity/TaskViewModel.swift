//
//  TaskViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation

public struct TaskViewModel: Equatable {
    public let id: String
    public let name: String
    public let taskDescription: String
    public let dateCreated: String
    public let isCompleted: Bool
    
    public init(
        id: String,
        name: String,
        taskDescription: String,
        dateCreated: String,
        isCompleted: Bool
    ) {
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
    }
}

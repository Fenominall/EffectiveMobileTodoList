//
//  TaskViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation

public struct FeedTodoTaskViewModel: Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public var isCompleted: Bool
    public let startTime: Date?
    public let endTime: Date?
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        isCompleted: Bool,
        startTime: Date? = nil,
        endTime: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
        self.startTime = startTime
        self.endTime = endTime
    }
}

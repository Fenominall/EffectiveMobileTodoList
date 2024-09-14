//
//  LocalTodoTask.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public struct LocalTodoTask: Equatable {
    public let id: UUID
    public var name: String
    public let description: String
    public let dateCreated: Date
    public let status: Bool
    public let startTime: Date?
    public let endTime: Date?
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        status: Bool,
        startTime: Date? = nil,
        endTime: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
    }
}

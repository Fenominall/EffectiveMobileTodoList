//
//  Task.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/3/24.
//

import Foundation

public struct TodoTask: Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public let status: Bool
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        status: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.status = status
    }
}

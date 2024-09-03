//
//  Task.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/3/24.
//

import Foundation

public struct TodoTask {
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public let status: Bool
}

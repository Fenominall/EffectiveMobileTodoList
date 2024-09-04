//
//  FeedTasksMapper.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/4/24.
//

import Foundation

public final class FeedTasksMapper {
    private struct Root: Decodable {
        let todos: [Item]
        
        var feed: [TodoTask] {
            return todos.map { $0.item }
        }
    }
    
    private struct Item: Decodable {
        let todo: String
        let completed: Bool
        
        var item: TodoTask {
            return TodoTask(
                id: UUID(),
                name: todo,
                description: todo,
                dateCreated: Date(),
                status: completed
            )
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static let jsonDecoder = JSONDecoder()
    
    public static func map(
        _ data: Data,
        from response: HTTPURLResponse
    ) throws -> [TodoTask] {
        guard response.statusCode == 200 else {
            throw Error.invalidData
        }
        
        let root = try jsonDecoder.decode(Root.self, from: data)
        
        return root.feed
    }
}

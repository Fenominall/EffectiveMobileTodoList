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
        let id: Int
        let todo: String
        let completed: Bool
        
        var item: TodoTask {
            let uuid = uuidFromID(id)
            print(uuid)
            return TodoTask(
                id: uuid,
                name: todo,
                description: todo,
                dateCreated: Date(),
                status: completed
            )
        }
        
        // Generate a consistent UUID from an integer ID
        private func uuidFromID(_ id: Int) -> UUID {
            // Create a UUID string from the integer ID
            let uuidString = String(format: "%08x-0000-0000-0000-000000000000", id)
            return UUID(uuidString: uuidString) ?? UUID()
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
        guard response.isOK else {
            throw Error.invalidData
        }
        
        let root = try jsonDecoder.decode(Root.self, from: data)
        
        return root.feed
    }
}

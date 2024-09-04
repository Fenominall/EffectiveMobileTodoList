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
        let id: String
        let todo: String
        let description: String?
        let completed: Bool
        let createdDate: String
        
        var item: TodoTask {
            let uuid = UUID(uuidString: id) ?? UUID()
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: createdDate) ?? Date()
            
            return TodoTask(
                id: uuid,
                name: todo,
                description: description ?? "",
                dateCreated: date,
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
        guard response.isOK else {
            throw Error.invalidData
        }
        
        let root = try jsonDecoder.decode(Root.self, from: data)
        
        return root.feed
    }
}

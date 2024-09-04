//
//  SharedTestHelpers.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/3/24.
//

import Foundation
import EffectiveMobileTodoList

func anyURL() -> URL {
    return URL(string: "https:any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error",
                   code: 1)
}

func anyData() -> Data {
    return Data("invalid json".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["todos": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

func makeTask(
    id: UUID = UUID(),
    name: String,
    description: String,
    dateCreated: Date,
    status: Bool
) -> (model: TodoTask, json: [String: Any]) {
    
    // Create the TodoTask model
    let task = TodoTask(
        id: id,
        name: name,
        description: description,
        dateCreated: dateCreated,
        status: status
    )
    
    // Create the corresponding JSON dictionary
    let json: [String: Any] = [
        "id": id.uuidString,
        "todo": name,
        "description": description,
        "createdDate": ISO8601DateFormatter().string(from: dateCreated),
        "completed": status
    ]
    
    return (task, json)
}

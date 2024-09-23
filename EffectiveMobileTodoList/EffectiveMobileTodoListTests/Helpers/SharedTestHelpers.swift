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
    id: Int,
    name: String,
    description: String,
    dateCreated: Date,
    status: Bool
) -> (model: TodoTask, json: [String: Any]) {
    
    let taskID = uuidFromID(id)
    
    let task = TodoTask(
        id: taskID,
        name: name,
        description: description,
        dateCreated: dateCreated,
        status: status
    )
    
    let json: [String: Any] = [
        "id": id,
        "todo": name,
        "description": description,
        "createdDate": ISO8601DateFormatter().string(from: dateCreated),
        "completed": status
    ]
    
    return (task, json)
}

private func uuidFromID(_ id: Int, existingUUID: UUID? = nil) -> UUID {
    if let uuid = existingUUID {
        return uuid // Use the existing UUID if provided
    }
    let uuidString = String(format: "%08x-0000-0000-0000-000000000000", id)
    return UUID(uuidString: uuidString) ?? UUID()
}


private func idFromInt(_ id: Int) -> Int {
    // Create a UUID-like string from the integer ID
    let uuidString = String(format: "%08x-0000-0000-0000-000000000000", id)
    
    // Extract the first 8 characters (the original integer portion)
    let intString = String(uuidString.prefix(8))
    
    // Convert the extracted string back to an integer
    return Int(intString, radix: 16) ?? 0
}


extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: anyURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
    }
}

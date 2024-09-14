//
//  TaskSaver.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/14/24.
//

import Foundation

public protocol TaskSaver {
    typealias SaveResult = Swift.Result<Void, Error>
    
    func save(selected task: TodoTask, completion: @escaping (SaveResult) -> Void)
}

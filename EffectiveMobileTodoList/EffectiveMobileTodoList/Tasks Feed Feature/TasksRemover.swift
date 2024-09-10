//
//  TasksRemover.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/10/24.
//

import Foundation

public protocol TasksRemover {
    typealias DeletionResult = Swift.Result<Void, Error>
    
    func delete(selected task: TodoTask, completion: @escaping (DeletionResult) -> Void)
}

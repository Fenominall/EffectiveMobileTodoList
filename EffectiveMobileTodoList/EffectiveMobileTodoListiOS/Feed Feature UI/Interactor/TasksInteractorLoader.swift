//
//  TasksInteractorLoader.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation

public protocol TasksInteractorLoader {
    typealias Result = Swift.Result<[TaskViewModel], Error>
    
    func loadTasks(completion: @escaping (Result) -> Void)
}

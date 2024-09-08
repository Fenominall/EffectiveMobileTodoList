//
//  TasksInteractorCache.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation

public protocol TasksInteractorSaver {
    typealias Result = Swift.Result<Void, Error>
    
    func saveTask(_ tasks: [TaskViewModel], completion: @escaping (Result) -> Void)
}

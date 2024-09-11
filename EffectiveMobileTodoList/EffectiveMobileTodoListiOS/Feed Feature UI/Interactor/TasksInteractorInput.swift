//
//  TasksInteractorInput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public protocol TasksInteractorInput {
    func loadTasks()
    func deleteTask(_ task: TodoTaskViewModel)
}

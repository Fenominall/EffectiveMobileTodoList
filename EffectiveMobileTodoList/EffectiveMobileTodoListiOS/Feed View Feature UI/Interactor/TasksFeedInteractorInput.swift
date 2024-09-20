//
//  TasksInteractorInput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksFeedInteractorInput {
    func loadTasks()
    func deleteTask(_ task: TodoTask)
    func saveTask(_ task: TodoTask)
    func updateTask(_ task: TodoTask)
}

//
//  TasksInteractorInput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksInteractorInput {
    func loadTasks()
    func deleteTask(_ task: TodoTask)
}

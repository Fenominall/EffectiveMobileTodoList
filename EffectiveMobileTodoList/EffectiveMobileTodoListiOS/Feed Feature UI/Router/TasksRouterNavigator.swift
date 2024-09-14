//
//  TasksRouterNavigator.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksRouterNavigator {
    func navigateToTaskDetails(for task: TodoTask)
    func addNewTask()
}

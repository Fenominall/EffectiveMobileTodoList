//
//  TasksRouterNavigator.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksFeedRouterNavigator {
    func navigateToTaskDetails(for task: TodoTask)
    func addNewTask()
}

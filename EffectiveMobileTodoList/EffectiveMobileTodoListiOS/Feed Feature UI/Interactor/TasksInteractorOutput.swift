//
//  TasksInteractorOutput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public protocol TasksInteractorOutput: AnyObject {
    func didLoadTasks(_ tasks: [TodoTaskViewModel])
    func didFailLoadingTasks(with error: Error)
    func didSaveTasks()
    func didFailSavingTasks(with error: Error)
}

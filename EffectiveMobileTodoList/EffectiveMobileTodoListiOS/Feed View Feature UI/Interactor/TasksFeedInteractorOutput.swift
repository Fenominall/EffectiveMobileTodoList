//
//  TasksInteractorOutput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksFeedInteractorOutput: AnyObject {
    func didStartOperation()
    func didLoadTasks(_ tasks: [TodoTask])
    func didSelectAddNewTask()
    func didFinish(with error: Error)
    func didFinishOperation()
}

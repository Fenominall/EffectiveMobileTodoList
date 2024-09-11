//
//  TasksInteractorOutput.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksInteractorOutput: AnyObject {
    func didStartOperation()
    func didLoadTasks(_ tasks: [TodoTask])
    func didFinish(with error: Error)
    func didFinishOperation()
}

//
//  TodoTaskInteractorOutput.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/18/24.
//

import EffectiveMobileTodoList

public protocol AddEditTaskInteractorOutput: AnyObject {
    func didSaveTask(_ task: TodoTask)
    func didDeleteTask(_ task: TodoTask)
    func didUpdateTask(_ task: TodoTask)
    func didFinishWithError(_ error: Error)
}

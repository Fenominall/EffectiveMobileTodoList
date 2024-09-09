//
//  TasksView.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public protocol TaskView: AnyObject {
    func displayTasks(_ tasks: [TodoTaskViewModel])
    func displayError(_ error: Error)
    func displaySaveSuccess()
}

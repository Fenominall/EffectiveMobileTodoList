//
//  TasksView.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public protocol TasksView: AnyObject {
    func displayTasks(_ viewModel: [TodoTaskViewModel])
}

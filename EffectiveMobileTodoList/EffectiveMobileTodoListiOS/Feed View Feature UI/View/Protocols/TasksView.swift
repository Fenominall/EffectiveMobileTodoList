//
//  TasksView.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksView: AnyObject {
    func displayTasks(_ viewModel: [TodoTask])
}

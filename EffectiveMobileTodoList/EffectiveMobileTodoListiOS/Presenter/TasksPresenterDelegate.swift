//
//  TasksPresenterProtocol.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksPresenterDelegate {
    func viewDidLoad()
    func didRequestTaskDeletion(_ task: TodoTask)
}

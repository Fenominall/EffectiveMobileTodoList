//
//  TasksPresenterProtocol.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public protocol TasksFeedPresenterDelegate {
    func viewDidLoad()
    func didRequestTaskDeletion(_ task: TodoTask)
}

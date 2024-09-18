//
//  TaskRouter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/13/24.
//

import UIKit
import EffectiveMobileTodoList

public class TasksFeedRouter: TasksFeedRouterNavigator {
    private weak var navigationController: UINavigationController?
    private let taskDetailComposer: (TodoTask) -> UIViewController
    private let addTaskComposer: () -> UIViewController
    
    public init(navigationController: UINavigationController,
                taskDetailComposer: @escaping (TodoTask) -> UIViewController,
                addTaskComposer: @escaping () -> UIViewController
    ) {
        self.navigationController = navigationController
        self.taskDetailComposer = taskDetailComposer
        self.addTaskComposer = addTaskComposer
    }
    
    public func navigateToTaskDetails(for task: EffectiveMobileTodoList.TodoTask) {
        let taskDetailsVC = taskDetailComposer(task)
        navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    public func addNewTask() {
        let addTaskVC = addTaskComposer()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
}

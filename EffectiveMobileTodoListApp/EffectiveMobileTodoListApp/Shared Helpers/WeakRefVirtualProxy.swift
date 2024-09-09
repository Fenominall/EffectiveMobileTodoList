//
//  WeakRefVirtualProxy.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoListiOS

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TaskLoadingView where T: TaskLoadingView {
    func display(_ viewModel: EffectiveMobileTodoListiOS.TaskLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: TaskErrorView where T: TaskErrorView {
    func display(_ viewModel: EffectiveMobileTodoListiOS.TaskErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: TasksView where T: TasksView {
    func displayTasks(_ viewModel: [TodoTaskViewModel]) {
        object?.displayTasks(viewModel)
    }
}

extension WeakRefVirtualProxy: TasksInteractorOutput where T: TasksInteractorOutput {
    func didStartOperation() {
        object?.didStartOperation()
    }
    
    func didLoadTasks(_ tasks: [EffectiveMobileTodoListiOS.TodoTaskViewModel]) {
        object?.didLoadTasks(tasks)
    }
    
    func didFinish(with error: any Error) {
        object?.didFinish(with: error)
    }
    
    func didSaveTasks() {
        object?.didSaveTasks()
    }
}

//
//  TasksPresenter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public final class TasksPresenter: TasksPresenterDelegate {
    private let view: TasksView
    private let errorView: TaskErrorView
    private let loadingView: TaskLoadingView
    private let interactor: TasksInteractorInput
    
    public init(
        view: TasksView,
        errorView: TaskErrorView,
        loadingView: TaskLoadingView,
        interactor: TasksInteractorInput
    ) {
        self.view = view
        self.errorView = errorView
        self.loadingView = loadingView
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        interactor.loadTasks()
    }
    
    public func didRequestTaskDeletion(_ task: TodoTaskViewModel) {
        interactor.deleteTask(task)
    }
}

extension TasksPresenter: TasksInteractorOutput {
    public func didStartOperation() {
        loadingView.display(TaskLoadingViewModel(isLoading: true))
        errorView.display(.noError)
    }
    
    public func didLoadTasks(_ tasks: [TodoTaskViewModel]) {
        loadingView.display(TaskLoadingViewModel(isLoading: false))
        errorView.display(.noError)
        view.displayTasks(tasks)
    }
    
    public func didFinish(with error: any Error) {
        loadingView.display(TaskLoadingViewModel(isLoading: false))
        errorView.display(.error(message: error.localizedDescription))
    }
    
    public func didFinishOperation() {
        loadingView.display(TaskLoadingViewModel(isLoading: false))
        errorView.display(.noError)
    }
}

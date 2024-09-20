//
//  TasksPresenter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

public final class TasksFeedPresenter: TasksFeedPresenterDelegate {
    private let view: TasksFeedView
    private let errorView: TaskErrorView
    private let loadingView: TaskLoadingView
    private let interactor: TasksFeedInteractorInput
    private let router: TasksFeedRouterNavigator
    
    public init(
        view: TasksFeedView,
        errorView: TaskErrorView,
        loadingView: TaskLoadingView,
        interactor: TasksFeedInteractorInput,
        router: TasksFeedRouterNavigator
    ) {
        self.view = view
        self.errorView = errorView
        self.loadingView = loadingView
        self.interactor = interactor
        self.router = router
    }
    
    public func viewDidLoad() {
        interactor.loadTasks()
    }
    
    public func didRequestTaskDeletion(_ task: TodoTask) {
        interactor.deleteTask(task)
    }
}

extension TasksFeedPresenter: TasksFeedInteractorOutput {
    public func didStartOperation() {
        loadingView.display(TaskLoadingViewModel(isLoading: true))
        errorView.display(.noError)
    }
    
    public func didLoadTasks(_ tasks: [TodoTask]) {
        loadingView.display(TaskLoadingViewModel(isLoading: false))
        errorView.display(.noError)
        view.displayTasks(tasks)
    }
    
    public func didSelectAddNewTask() {
        router.addNewTask()
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

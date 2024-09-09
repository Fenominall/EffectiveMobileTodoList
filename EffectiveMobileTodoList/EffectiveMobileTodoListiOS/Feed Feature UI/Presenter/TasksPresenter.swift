//
//  TasksPresenter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public final class TasksPresenter: TasksPresenterDelegate {
    
    private let view: TasksView
    private let interactor: TasksInteractorInput
    
    public init(view: TasksView, interactor: TasksInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        interactor.loadTasks()
    }
    
    public func saveTasks(_ tasks: [TodoTaskViewModel]) {
        interactor.saveTasks(tasks)
    }
}

extension TasksPresenter: TasksInteractorOutput {
    public func didLoadTasks(_ tasks: [TodoTaskViewModel]) {
        view.displayTasks(tasks)
    }
    
    public func didFailLoadingTasks(with error: any Error) {
        view.displayError(error)
    }
    
    public func didSaveTasks() {
        view.displaySaveSuccess()
    }
    
    public func didFailSavingTasks(with error: any Error) {
        view.displayError(error)
    }
}

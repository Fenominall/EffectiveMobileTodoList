//
//  TaskPresenter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/18/24.
//

import Foundation
import EffectiveMobileTodoList

public final class AddEditTaskPresenter {
    private let interactor: AddEditTaskInteractor
    private let router: AddEditTaskNavigationRouter
    
    public init(
        interactor: AddEditTaskInteractor,
        router: AddEditTaskNavigationRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
}

extension AddEditTaskPresenter: AddEditTaskInteractorOutput {
    public func didSaveTask(_ task: EffectiveMobileTodoList.TodoTask) {
        interactor.deleteTask(task)
        router.routeToTasksFeed()
    }
    
    public func didDeleteTask(_ task: EffectiveMobileTodoList.TodoTask) {
        interactor.deleteTask(task)
        router.routeToTasksFeed()
    }
    
    public func didUpdateTask(_ task: EffectiveMobileTodoList.TodoTask) {
        interactor.update(task)
        router.routeToTasksFeed()
    }
    
    public func didFinishWithError(_ error: any Error) {
        
    }
}

//
//  AddTaskUIComposer.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/14/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class AddTaskUIComposer {
    private init() {}
    
    static func composedWith(taskSaver: TaskSaver, taskRemover: TasksRemover) -> AddEditTodoTaskViewController {
        var viewModel = AddEditTodoTaskViewModel()
        let controller = AddEditTodoTaskViewController(viewModel: viewModel)
        let router = AddEditTaskRouter(controller: controller)
        
        let interactor = AddEditTaskInteractor(
            taskSaver: MainQueueDispatchDecorator(decoratee: taskSaver),
            taskRemover: MainQueueDispatchDecorator(decoratee: taskRemover)
        )
        let presenter = AddEditTaskPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        
        viewModel.onSaveAddTransaction = presenter.didSaveTask
        
        return controller
    }
}

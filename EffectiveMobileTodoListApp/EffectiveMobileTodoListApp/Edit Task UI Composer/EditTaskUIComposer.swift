//
//  Edit Task UI Composer.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/15/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class EditTaskUIComposer {
    private init() {}
    
    static func composedWith(
        selectedModel: TodoTask,
        taskSaver: TaskSaver,
        taskRemover: TasksRemover
    ) -> AddEditTodoTaskViewController {
        var viewModel = AddEditTodoTaskViewModel(task: selectedModel)
        let controller = AddEditTodoTaskViewController(viewModel: viewModel)
        let router = AddEditTaskRouter(controller: controller)
        
        let interactor = AddEditTaskInteractor(taskSaver: taskSaver, taskRemover: taskRemover)
        let presenter = AddEditTaskPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
    
        viewModel.onSaveUpdateTransaction = presenter.didUpdateTask
        viewModel.deletionHandler = { [weak presenter] in
            presenter?.didDeleteTask(selectedModel)
        }
        
        
        return controller
    }
}

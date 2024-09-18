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
    
    static func composedWith(selectedModel: TodoTask) -> AddEditTodoTaskViewController {
        let viewModel = AddEditTodoTaskViewModel(task: selectedModel)
        let controller = AddEditTodoTaskViewController(viewModel: viewModel)
        return controller
    }
}

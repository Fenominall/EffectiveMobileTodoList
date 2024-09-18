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
    
    static func composedWith() -> AddEditTodoTaskViewController {
        let viewModel = AddEditTodoTaskViewModel()
        let controller = AddEditTodoTaskViewController(viewModel: viewModel)
        return controller
    }
}

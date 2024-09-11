//
//  TasksFeedViewAdapter.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class TasksFeedViewAdapter: TasksView {
    private weak var controller: TaskListViewController?
    private let selection: (TodoTask) -> Void
    private let onDelete: (TodoTask) -> Void
    
    init(controller: TaskListViewController,
         selection: @escaping (TodoTask) -> Void,
         onDelete: @escaping (TodoTask) -> Void
    ) {
        self.controller = controller
        self.selection = selection
        self.onDelete = onDelete
    }
    
    func displayTasks(_ viewModel: [TodoTask]) {
        controller?.tableModel = viewModel.map { model in
            TasksTableCellController(viewModel: mapToTodoViewModel(from: model),
                                     selection: { [weak self] in
                guard let self = self else { return }
                self.selection(model)
            },
                                     deleteHandler: { [weak self] in
                guard let self = self else { return }
                self.onDelete(model)
            })
        }
    }
    
    private func mapToTodoViewModel(from dto: TodoTask) -> TodoTaskViewModel {
        return TodoTaskViewModel(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            dateCreated: dto.dateCreated,
            isCompleted: dto.status
        )
    }
}

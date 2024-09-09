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
    
    init(controller: TaskListViewController,
         selection: @escaping (TodoTask) -> Void) {
        self.controller = controller
        self.selection = selection
    }
    
    func displayTasks(_ viewModel: [EffectiveMobileTodoListiOS.TodoTaskViewModel]) {
        controller?.tableModel = viewModel.map { [weak self] model in
            guard let self = self else {
                return TasksTableCellController(viewModel: model,
                                                selection: {
                }) }
            
            return TasksTableCellController(viewModel: model,
                                            selection: {
                [selection] in
                selection(self.mapToTodoTask(from: model))
            })
        }
    }
    
    private func mapToTodoTask(from dto: TodoTaskViewModel) -> TodoTask {
        return TodoTask(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            dateCreated: dto.dateCreated,
            status: dto.isCompleted
        )
    }
}

//
//  TasksFeedViewAdapter.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class TasksFeedViewAdapter: TasksFeedView {
    private weak var controller: TaskListViewController?
    private let selection: (TodoTask) -> UIViewController
    private var onDelete: ((TodoTask) -> Void)?
    private var onUpdate: ((TodoTask) -> Void)?
    
    init(controller: TaskListViewController,
         selection: @escaping (TodoTask) -> UIViewController
    ) {
        self.controller = controller
        self.selection = selection
    }
    
    func setOnDeleteHandler(_ handler: @escaping (TodoTask) -> Void) {
        self.onDelete = handler
    }
    
    func setOnUpdateHandler(_ handler: @escaping (TodoTask) -> Void) {
        self.onUpdate = handler
    }
    
    func displayTasks(_ viewModel: [TodoTask]) {
        controller?.tableModel = viewModel.map { model in
            TasksTableCellController(viewModel: mapToTodoViewModel(from: model),
                                     selection: { [weak self] in
                guard let self = self else { return }
                _ = self.selection(model)
            },
                                     deleteHandler: { [weak self] in
                guard let self = self else { return }
                self.onDelete?(model)
            }, onTaskCompletionToggle: { [weak self] updatedTask in
                self?.onUpdate?(updatedTask.toDomainModel())
                self?.controller?.onRefresh?()
            })
        }
    }
    
    private func mapToTodoViewModel(from dto: TodoTask) -> FeedTodoTaskViewModel {
        return FeedTodoTaskViewModel(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            dateCreated: dto.dateCreated,
            isCompleted: dto.status,
            startTime: dto.startTime,
            endTime: dto.endTime
        )
    }
}

extension FeedTodoTaskViewModel {
    func toDomainModel() -> TodoTask {
        return TodoTask(
            id: id,
            name: name,
            description: description,
            dateCreated: dateCreated,
            status: isCompleted,
            startTime: startTime,
            endTime: endTime
        )
    }
}


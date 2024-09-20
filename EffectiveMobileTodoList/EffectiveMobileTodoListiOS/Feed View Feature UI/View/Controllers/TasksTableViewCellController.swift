//
//  TasksTableViewCellController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import Foundation

public final class TasksTableCellController {
    private(set) var viewModel: FeedTodoTaskViewModel
    private var cell: TaskTableViewCell?
    private(set) var selection: () -> Void
    private(set) var deleteHandler: () -> Void
    private(set) var onTaskCompletionToggle: (FeedTodoTaskViewModel) -> Void
    
    public init(
        viewModel: FeedTodoTaskViewModel,
        selection: @escaping () -> Void,
        deleteHandler: @escaping () -> Void,
        onTaskCompletionToggle: @escaping (FeedTodoTaskViewModel) -> Void
    ) {
        self.viewModel = viewModel
        self.selection = selection
        self.deleteHandler = deleteHandler
        self.onTaskCompletionToggle = onTaskCompletionToggle
    }
    
    public func view() -> UITableViewCell {
        if cell == nil {
            cell = binded(TaskTableViewCell())
        }
        
        return cell ?? UITableViewCell()
    }
    
    private func binded(_ cell: TaskTableViewCell) -> TaskTableViewCell {
        cell.configure(
            withName: viewModel.name,
            description: viewModel.description,
            timeDate: convertDateForShort(with: viewModel.dateCreated),
            taskStartTime: convertDate(with: viewModel.startTime),
            taskEndTime: convertDate(with: viewModel.endTime),
            isCompleted: viewModel.isCompleted,
            checkmarkTappedHandler: { [weak self] isCompleted in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.isCompleted = isCompleted
                strongSelf.onTaskCompletionToggle(strongSelf.viewModel)
            }

        )
        return cell
    }
}

//
//  TasksTableViewCellController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import Foundation

public final class TasksTableCellController {
    private let viewModel: TodoTaskViewModel
    private var cell: TaskTableViewCell?
    private(set) var selection: () -> Void
    
    public init(viewModel: TodoTaskViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
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
            timeDate: convertDate(with: viewModel.dateCreated),
            specificTime: convertDateForShort(with: viewModel.dateCreated),
            isCompleted: viewModel.isCompleted
        )
        return cell
    }
}

extension TasksTableCellController: TaskLoadingView {
    public func display(_ viewModel: TaskLoadingViewModel) {
        
    }
}

extension TasksTableCellController: TaskErrorView {
    public func display(_ viewModel: TaskErrorViewModel) {
        
    }
}

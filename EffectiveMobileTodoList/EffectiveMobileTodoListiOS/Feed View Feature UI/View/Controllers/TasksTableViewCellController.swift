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
    
    public init(
        viewModel: FeedTodoTaskViewModel,
        selection: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.selection = selection
        self.deleteHandler = deleteHandler
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
            specificTime: convertDate(with: viewModel.dateCreated),
            isCompleted: viewModel.isCompleted
        )
        return cell
    }
}

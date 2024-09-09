//
//  TasksTableViewCellController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import Foundation

public final class TasksTableViewCellController {
    private let viewModel: TodoTaskViewModel
    private var cell: TaskTableViewCell?
    
    public init(viewModel: TodoTaskViewModel) {
        self.viewModel = viewModel
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

//
//  TaskInteractor.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/18/24.
//

import Foundation
import EffectiveMobileTodoList

public final class AddEditTaskInteractor {
    public weak var presenter: TodoTaskInteractorOutput?
    private let taskSaver: TaskSaver
    private let taskRemover: TasksRemover
    
    public init(
        taskSaver: TaskSaver,
        taskRemover: TasksRemover
    ) {
        self.taskSaver = taskSaver
        self.taskRemover = taskRemover
    }
}

extension AddEditTaskInteractor: TodoTaskInteractorInput {
    public func saveTask(_ task: EffectiveMobileTodoList.TodoTask) {
        taskSaver.save(task) { [weak self] result in
            switch result {
                
            case .success:
                break
            case let .failure(error):
                self?.presenter?.didFinishWithError(error)
                }
        }
    }
    
    public func update(_ task: EffectiveMobileTodoList.TodoTask) {
        taskSaver.update(task) { [weak self] result in
            switch result {
                
            case .success:
                break
            case let .failure(error):
                self?.presenter?.didFinishWithError(error)
            }
        }
    }
    
    public func deleteTask(_ task: EffectiveMobileTodoList.TodoTask) {
        taskRemover.delete(selected: task) { [weak self] result in
            switch result {
                
            case .success:
                break
            case let .failure(error):
                self?.presenter?.didFinishWithError(error)
            }
        }
    }
}

//
//  TasksInteractor.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation
import EffectiveMobileTodoList

public final class TasksFeedInteractor: TasksFeedInteractorInput {
    public weak var presenter: TasksFeedInteractorOutput?
    private let loader: TasksLoader
    private let remover: TasksRemover
    private let taskSaver: TaskSaver
    
    public init(
        loader: TasksLoader,
        remover: TasksRemover,
        taskSaver: TaskSaver
    ) {
        self.loader = loader
        self.remover = remover
        self.taskSaver = taskSaver
    }
}

// Load Tasks
extension TasksFeedInteractor {
    public func loadTasks() {
        presenter?.didStartOperation()
        
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case let .success(tasks):
                self.presenter?.didLoadTasks(tasks)
            case let .failure(error):
                self.presenter?.didFinish(with: error)
            }
        }
    }
}

// Save Task
extension TasksFeedInteractor {
    public func saveTask(_ task: EffectiveMobileTodoList.TodoTask) {
        taskSaver.save(task) { [weak self] result in
            switch result {
                
            case .success:
                self?.presenter?.didFinishOperation()
            case let .failure(error):
                self?.presenter?.didFinish(with: error)
            }
        }
    }
}

// Delete Tasks
extension TasksFeedInteractor {
    public func deleteTask(_ task: TodoTask) {
        presenter?.didStartOperation()
        
        remover.delete(selected: task) { [weak self] result in
            switch result {
                
            case .success:
                self?.presenter?.didFinishOperation()
            case let .failure(error):
                self?.presenter?.didFinish(with: error)
            }
        }
    }
}

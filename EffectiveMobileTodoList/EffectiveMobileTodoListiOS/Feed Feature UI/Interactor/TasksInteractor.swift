//
//  TasksInteractor.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation
import EffectiveMobileTodoList

public final class TasksInteractor: TasksInteractorInput {
    public weak var presenter: TasksInteractorOutput?
    private let loader: TasksLoader
    private let remover: TasksRemover
    
    public init(
        loader: TasksLoader,
        remover: TasksRemover
    ) {
        self.loader = loader
        self.remover = remover
    }
}

// Load Tasks
extension TasksInteractor {
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

// Delete Tasks
extension TasksInteractor {
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

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
                self.presenter?.didLoadTasks(tasks.toViewModels())
            case let .failure(error):
                self.presenter?.didFinish(with: error)
            }
        }
    }
}

// Delete Tasks
extension TasksInteractor {
    public func deleteTask(_ task: TodoTaskViewModel) {
        presenter?.didStartOperation()
        
        remover.delete(selected: mapToTodoTask(from: task)) { [weak self] result in
            switch result {
                
            case .success:
                self?.presenter?.didFinishOperation()
            case let .failure(error):
                self?.presenter?.didFinish(with: error)
            }
        }
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

private extension Array where Element == TodoTask {
    func toViewModels() -> [TodoTaskViewModel] {
        return map {
            TodoTaskViewModel(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                isCompleted: $0.status
            )
        }
    }
}

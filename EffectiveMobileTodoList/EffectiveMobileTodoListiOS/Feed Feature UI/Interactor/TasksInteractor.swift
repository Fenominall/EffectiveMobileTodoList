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

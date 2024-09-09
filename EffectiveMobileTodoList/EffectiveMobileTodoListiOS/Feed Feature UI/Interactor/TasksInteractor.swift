//
//  TasksInteractor.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation
import EffectiveMobileTodoList

public final class TasksInteractor: TasksInteractorInput {
    private let presenter: TasksInteractorOutput
    private let loader: TasksLoader
    private let cache: TasksFeedCache
    
    public init(
        loader: TasksLoader,
        cache: TasksFeedCache,
        presenter: TasksInteractorOutput
    ) {
        self.loader = loader
        self.cache = cache
        self.presenter = presenter
    }
}

// Load Tasks
extension TasksInteractor {
    public func loadTasks() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case let .success(tasks):
                self.presenter.didLoadTasks(tasks.toViewModels())
            case let .failure(error):
                self.presenter.didFailLoadingTasks(with: error)
            }
        }
    }
}

// Save Tasks
extension TasksInteractor {
    public func saveTasks(_ tasks: [TodoTaskViewModel]) {
        cache.save(tasks.toModels()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success:
                self.presenter.didSaveTasks()
            case let .failure(error):
                self.presenter.didFailSavingTasks(with: error)
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

private extension Array where Element == TodoTaskViewModel {
    func toModels() -> [TodoTask] {
        return map {
            TodoTask(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                status: $0.isCompleted
            )
        }
    }
}

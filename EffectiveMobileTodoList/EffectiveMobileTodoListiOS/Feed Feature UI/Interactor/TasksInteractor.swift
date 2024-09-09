//
//  TasksInteractor.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import Foundation
import EffectiveMobileTodoList

public final class TasksInteractor: TasksInteractorManager {
    private let loader: TasksLoader
    private let cache: TasksFeedCache
    
    public init(loader: TasksLoader, cache: TasksFeedCache) {
        self.loader = loader
        self.cache = cache
    }
    
    public func loadTasks(completion: @escaping (TasksInteractorLoader.Result) -> Void) {
        loader.load { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case let .success(tasks):
                completion(.success(tasks.toModels()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func saveTask(_ tasks: [TaskViewModel], completion: @escaping (TasksInteractorSaver.Result) -> Void) {
        cache.save(tasks.toLocale()) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case .success():
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
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

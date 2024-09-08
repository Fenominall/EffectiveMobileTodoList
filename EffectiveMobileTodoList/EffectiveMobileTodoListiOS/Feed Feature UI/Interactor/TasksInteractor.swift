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
    
    init(loader: TasksLoader, cache: TasksFeedCache) {
        self.loader = loader
        self.cache = cache
    }
    
    public func loadTasks(completion: @escaping (TasksInteractorLoader.Result) -> Void) {
        loader.load { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case let .success(tasks):
                completion(.success(tasks.toModels()))

            case .failure(_):
                // Todo
                break
            }
        }
    }
    
    public func saveTask(_ tasks: [TaskViewModel], completion: @escaping (TasksInteractorSaver.Result) -> Void) {
        
    }
    
    // MARK: - Helpers
    
}

private extension Array where Element == TodoTask {
    func toModels() -> [TaskViewModel] {
        return map {
            TaskViewModel(
                id: $0.id,
                name: $0.name,
                description: $0.description,
                dateCreated: $0.dateCreated,
                isCompleted: $0.status
            )
        }
    }
}

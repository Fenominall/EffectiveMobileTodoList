//
//  TasksFeedLoaderWithFallbackComposite.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/10/24.
//

import Foundation
import EffectiveMobileTodoList

final class TasksFeedLoaderWithFallbackComposite: TasksLoader {
    private let primary: TasksLoader
    private let fallback: TasksLoader
    
    init(primary: TasksLoader, fallback: TasksLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (TasksLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}

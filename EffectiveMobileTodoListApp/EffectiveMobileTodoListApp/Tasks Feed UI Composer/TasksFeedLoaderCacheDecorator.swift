//
//  TasksFeedLoaderCacheDecorator.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/10/24.
//

import Foundation
import EffectiveMobileTodoList

final class TasksFeedLoaderCacheDecorator: TasksLoader {
    private let decoratee: TasksLoader
    private let cache: TasksFeedCache
    
    init(decoratee: TasksLoader, cache: TasksFeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (TasksLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map({ feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            }))
        }
    }
}

private extension TasksFeedCache {
    func saveIgnoringResult(_ feed: [TodoTask]) {
        save(feed) { _ in }
    }
}

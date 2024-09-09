//
//  MainQueueDispatchDecorator.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void){
        guard Thread.isMainThread else {
            return DispatchQueue.main.asyncAndWait(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: TasksLoader where T == TasksLoader {
    func load(completion: @escaping (TasksLoader.Result) -> Void) {
        return decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

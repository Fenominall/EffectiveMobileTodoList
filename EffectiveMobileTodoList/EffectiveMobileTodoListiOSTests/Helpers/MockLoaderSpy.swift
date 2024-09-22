//
//  MockLoaderSpy.swift
//  EffectiveMobileTodoListiOSTests
//
//  Created by Fenominall on 9/22/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class MockLoaderSpy: TasksLoader {
    private var loadMessages = [(TasksLoader.Result) -> Void]()
    private var saveTasksMessages = [(SaveResult) -> Void]()
    private var saveTaskMessages = [(SaveResult) -> Void]()
    private var updateTaskMessages = [(SaveResult) -> Void]()
    private var deleteTaskMessages = [(DeletionResult) -> Void]()
        
    func load(completion: @escaping (TasksLoader.Result) -> Void) {
        loadMessages.append(completion)
    }
}

extension MockLoaderSpy: TaskSaver {
    func save(_ task: EffectiveMobileTodoList.TodoTask, completion: @escaping (SaveResult) -> Void) {
        saveTaskMessages.append(completion)
    }
    
    func update(_ task: EffectiveMobileTodoList.TodoTask, completion: @escaping (SaveResult) -> Void) {
        updateTaskMessages.append(completion)
    }
}

extension MockLoaderSpy: TasksFeedCache {
    func save(_ feed: [TodoTask], completion: @escaping (SaveResult) -> Void) {
        saveTasksMessages.append(completion)
    }
}

extension MockLoaderSpy: TasksRemover {
    func delete(selected task: EffectiveMobileTodoList.TodoTask, completion: @escaping (DeletionResult) -> Void) {
        deleteTaskMessages.append(completion)
    }
}

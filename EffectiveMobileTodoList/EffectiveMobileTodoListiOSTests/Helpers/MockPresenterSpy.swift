//
//  MockPresenterSpy.swift
//  EffectiveMobileTodoListiOSTests
//
//  Created by Fenominall on 9/22/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class MockPresenterSpy: TasksFeedInteractorOutput {
    var didStartOperationCallCount = 0
    var didLoadTasksCallCount = 0
    var didFinishWithErrorCallCount = 0
    var didFinishOperationCallCount = 0
    var didSelectAddNewTaskCallCount = 0
    var loadedTasks: [TodoTask] = []
    var receivedError: Error?
    
    func didStartOperation() {
        didStartOperationCallCount += 1
    }
    
    func didLoadTasks(_ tasks: [EffectiveMobileTodoList.TodoTask]) {
        didLoadTasksCallCount += 1
        self.loadedTasks = tasks
    }
    
    func didSelectAddNewTask() {
        didSelectAddNewTaskCallCount += 1
    }
    
    func didFinish(with error: any Error) {
        didFinishWithErrorCallCount += 1
        receivedError = error
    }
    
    func didFinishOperation() {
        didFinishOperationCallCount += 1
    }
}

//
//  TaskFeedInteractorTestCase.swift
//  EffectiveMobileTodoListiOSTests
//
//  Created by Fenominall on 9/22/24.
//

import XCTest
import EffectiveMobileTodoListiOS

final class TasksFeedInteractorTests: XCTestCase {
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) ->  TasksFeedInteractor {
        let loaderSpy = MockLoaderSpy()
        let presenterSpy = MockPresenterSpy()
        
        let interactor = TasksFeedInteractor(loader: loaderSpy, remover: loaderSpy, taskSaver: loaderSpy)
        interactor.presenter = presenterSpy
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        trackForMemoryLeaks(presenterSpy, file: file, line: line)
        trackForMemoryLeaks(interactor, file: file, line: line)
        return interactor
    }
}

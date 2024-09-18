//
//  TaskErrorViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import Foundation

public struct TaskErrorViewModel {
    public let message: String?
    
    static var noError: TaskErrorViewModel {
        return TaskErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> TaskErrorViewModel {
        return TaskErrorViewModel(message: message)
    }
}

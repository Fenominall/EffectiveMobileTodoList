//
//  TaskStatus.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/15/24.
//

import Foundation

enum TaskStatus {
    case open
    case closed
    
    var isCompleted: Bool {
        switch self {
        case .open:
            return false
        case .closed:
            return true
        }
    }
}

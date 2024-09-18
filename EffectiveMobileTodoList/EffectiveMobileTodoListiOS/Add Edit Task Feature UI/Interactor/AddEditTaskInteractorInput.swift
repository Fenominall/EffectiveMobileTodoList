//
//  TasksFeedInteractorInput.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/18/24.
//


import Foundation
import EffectiveMobileTodoList

public protocol AddEditTaskInteractorInput {
    func saveTask(_ task: TodoTask)
    func update(_ task: TodoTask)
    func deleteTask(_ task: TodoTask)
}

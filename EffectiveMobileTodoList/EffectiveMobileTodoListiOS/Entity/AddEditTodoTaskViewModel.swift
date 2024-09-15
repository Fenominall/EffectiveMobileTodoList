//
//  AddEditTodoTaskViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/14/24.
//

import Foundation
import EffectiveMobileTodoList

public struct AddEditTodoTaskViewModel: Equatable {
    var taskToEdit: TodoTask?
    
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public var isCompleted: Bool
    public var startTime: Date?
    public var endTime: Date?
    
    public var selectedStartTime: Date? {
        didSet {
            if selectedStartTime != nil {
                startTime = selectedStartTime
            }
        }
    }
    
    public var selectedEndTime: Date? {
        didSet {
            if selectedEndTime != nil {
                endTime = selectedEndTime
            }
        }
    }
    
    var hasSelectedTimes: Bool {
        return selectedStartTime != nil || selectedEndTime != nil
    }
    
    public init() {
        self.id = UUID()
        self.name = ""
        self.description = ""
        self.dateCreated = Date()
        self.isCompleted = false
        self.startTime = nil
        self.endTime = nil
    }
    
    public init(
        viewModel: TodoTask
    ) {
        self.taskToEdit = viewModel
        self.id = viewModel.id
        self.name = viewModel.name
        self.description = viewModel.description
        self.dateCreated = viewModel.dateCreated
        self.isCompleted = viewModel.status
        self.startTime = viewModel.startTime
        self.endTime = viewModel.endTime
        
    }
    
    public init(
        id: UUID,
        name: String,
        description: String,
        dateCreated: Date,
        isCompleted: Bool,
        startTime: Date? = nil,
        endTime: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
        self.startTime = startTime
        self.endTime = endTime
    }
}

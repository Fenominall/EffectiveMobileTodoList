//
//  AddEditTodoTaskViewModel.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/14/24.
//

import Foundation
import EffectiveMobileTodoList

public final class AddEditTodoTaskViewModel {
    private var taskToEdit: TodoTask?
    public var status: TaskStatus
    
    public let id: UUID
    public let name: String
    public let description: String
    public let dateCreated: Date
    public var startTime: Date?
    public var endTime: Date?
    
    public var deletionHandler: (() -> Void)?
    public var onSaveAddTransaction: ((TodoTask) -> Void)?
    public var onSaveUpdateTransaction: ((TodoTask) -> Void)?
    
    public init(
        task: TodoTask? = nil
    ) {
        if let task = task {
            self.id = task.id
            self.name = task.name
            self.description = task.description
            self.dateCreated = task.dateCreated
            self.status = task.status ? .closed : .open
            self.startTime = task.startTime
            self.endTime = task.endTime
        } else {
            self.id = UUID()
            self.name = ""
            self.description = ""
            self.dateCreated = Date()
            self.status = .open
            self.startTime = nil
            self.endTime = nil
        }
        self.taskToEdit = task
    }
    
    public var isEditing: Bool {
        return taskToEdit != nil
    }
    
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
    
    public var isCompleted: Bool {
        status.isCompleted
    }
    
    var hasSelectedTimes: Bool {
        return selectedStartTime != nil || selectedEndTime != nil
    }
    
    func saveTask(
        name: String,
        description: String,
        status: TaskStatus,
        dateCreated: Date,
        taskStartTime: Date,
        taskEndTime: Date
    ) {
        let todoTask = TodoTask(
            id: taskToEdit?.id ?? UUID(),
            name: name,
            description: description,
            dateCreated: dateCreated,
            status: status.isCompleted,
            startTime: taskStartTime,
            endTime: taskEndTime
        )
    
        taskToEdit != nil ?
        onSaveUpdateTransaction?(todoTask) :
        onSaveAddTransaction?(todoTask)
    }
    
    func deletetask() {
        deletionHandler?()
    }
}

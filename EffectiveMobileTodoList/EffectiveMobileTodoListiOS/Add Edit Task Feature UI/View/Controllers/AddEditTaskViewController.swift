//
//  AddEditTaskViewController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/10/24.
//

import UIKit

public class AddEditTaskViewController: UIViewController {
    
    // MARK: - UI Elements
    private let taskNameTextField = makeTextField(with: "Task Name")
    private let taskDescriptionTextField = makeTextField(with: "Task Description")
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Task date:".capitalized
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Task start time:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let startTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Task end time:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let endTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status:".capitalized
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }() 
    
    private lazy var openStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Open".capitalized
        return label
    }()
    
    private lazy var closedStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Closed".capitalized
        return label
    }()
    
    private lazy var openStatusButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.tag = 0
        //        button.addTarget(
        //            self,
        //            action: #selector(radioButtonTapped(_:)),
        //            for: .touchUpInside
        //        )
        return button
    }()
    
    private lazy var closedStatusButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.tag = 1
        //        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var openStatusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [openStatusButton, openStatusLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var closedStatusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [closedStatusButton, closedStatusLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusLabel, openStatusStackView, closedStatusStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 30
        return stack
    }()
    
    // MARK: - Properties
    var isEditingTask: Bool = false {
        didSet {
            navigationItem.title = isEditingTask ? "Edit Task" : "Add Task"
            deleteButton.isHidden = !isEditingTask
        }
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Configure navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.addSubview(taskNameTextField)
        view.addSubview(taskDescriptionTextField)
        view.addSubview(statusStackView)
        view.addSubview(taskDateLabel)
        view.addSubview(datePicker)
        view.addSubview(startTimeLabel)
        view.addSubview(startTimePicker)
        view.addSubview(endTimeLabel)
        view.addSubview(endTimePicker)
        view.addSubview(deleteButton)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            taskDescriptionTextField.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 20),
            taskDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskDescriptionTextField.heightAnchor.constraint(equalToConstant: 44),
            
            statusStackView.topAnchor.constraint(equalTo: taskDescriptionTextField.bottomAnchor, constant: 30),
            statusStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            taskDateLabel.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 30),
            taskDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            datePicker.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startTimeLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            startTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startTimePicker.centerYAnchor.constraint(equalTo: startTimeLabel.centerYAnchor),
            
            startTimePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            startTimePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            endTimeLabel.topAnchor.constraint(equalTo: startTimePicker.bottomAnchor, constant: 20),
            endTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            endTimePicker.centerYAnchor.constraint(equalTo: endTimeLabel.centerYAnchor),
            endTimePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endTimePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Actions
    @objc private func saveTask() {
        // Logic to save or update the task
    }
    
    @objc private func deleteTask() {
        // Logic to delete the task
    }
}

extension AddEditTaskViewController {
    // MARK: - Helpers
    
    private static func makeTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 12
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.borderStyle = .roundedRect
        return textField
    }
}

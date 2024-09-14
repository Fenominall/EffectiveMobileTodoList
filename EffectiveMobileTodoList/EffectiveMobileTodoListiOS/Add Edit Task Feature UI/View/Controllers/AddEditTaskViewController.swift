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
        makeLabel(with: "Task date:".capitalized, font: .headline)
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = makeDatePicker(withMode: .date)
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private lazy var startTimeLabel: UILabel = {
        makeLabel(with: "Task start time:", font: .headline)
    }()
    
    private lazy var startTimePicker: UIDatePicker = {
        makeDatePicker(withMode: .time)
    }()
    
    private lazy var endTimeLabel: UILabel = {
        makeLabel(with: "Task end time:", font: .headline)
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        makeDatePicker(withMode: .time)
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
        makeLabel(with: "Status:".capitalized, font: .headline)
    }()
    
    private lazy var openStatusLabel: UILabel = {
        makeLabel(with: "Open:".capitalized, font: .headline)
    }()
    
    private lazy var closedStatusLabel: UILabel = {
        makeLabel(with: "Closed:".capitalized, font: .headline)
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
        makeStackView(
            withViews: [openStatusButton, openStatusLabel],
            stackAxis: .horizontal,
            spacing: 5
        )
    }()
    
    private lazy var closedStatusStackView: UIStackView = {
        makeStackView(
            withViews: [closedStatusButton, closedStatusLabel],
            stackAxis: .horizontal,
            spacing: 5
        )
    }()
    
    private lazy var statusStackView: UIStackView = {
        makeStackView(
            withViews: [statusLabel, openStatusStackView, closedStatusStackView],
            stackAxis: .horizontal,
            spacing: 30
        )
    }()
    
    // MARK: - Properties
    private var isEditingTask: Bool = false {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTask)
        )
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
    
    private func makeLabel(
        with title: String,
        font preferredFont: UIFont.TextStyle
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: preferredFont)
        return label
    }
    
    private func makeDatePicker(withMode mode: UIDatePicker.Mode) -> UIDatePicker {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = mode
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }
    
    private func makeStackView(
        withViews views:  [UIView],
        stackAxis axis: NSLayoutConstraint.Axis,
        spacing space: CGFloat
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = space
        return stack
    }
}

//
//  AddEditTaskViewController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/10/24.
//

import UIKit

public class AddEditTodoTaskViewController: UIViewController {
    private var viewModel: AddEditTodoTaskViewModel
    
    // MARK: - UI Elements
    private lazy var nameLabel = makeLabel(with: "Name", font: .headline)
    private lazy var descriptionLabel = makeLabel(with: "Description", font: .headline)
    private let taskNameTextField = makeTextField(with: "Task Name")
    private let taskDescriptionTextField = makeTextField(with: "Task Description")
    private lazy var taskDateLabel = makeLabel(with: "Task date:".capitalized, font: .headline)
    private lazy var datePicker: UIDatePicker = {
        let picker = makeDatePicker(withMode: .date)
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    private lazy var startTimeLabel = makeLabel(with: "Task start time:", font: .headline)
    private lazy var startTimePicker = makeDatePicker(withMode: .time)
    private lazy var endTimeLabel = makeLabel(with: "Task end time:", font: .headline)
    private lazy var endTimePicker = makeDatePicker(withMode: .time)
    
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
    
    private lazy var statusLabel = makeLabel(with: "Status:".capitalized, font: .headline)
    private lazy var openStatusLabel = makeLabel(with: "Open:".capitalized, font: .headline)
    private lazy var closedStatusLabel = makeLabel(with: "Closed:".capitalized, font: .headline)
    
    private lazy var openStatusButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.tag = 0
        button.addTarget(
            self,
            action: #selector(radioButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var closedStatusButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.tag = 1
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var openStatusStackView = makeStackView(
        withViews: [openStatusLabel, openStatusButton],
        stackAxis: .horizontal,
        spacing: 5)
    
    private lazy var closedStatusStackView = makeStackView(
        withViews: [closedStatusLabel, closedStatusButton],
        stackAxis: .horizontal,
        spacing: 5)
    
    private lazy var statusStackView = makeStackView(
        withViews: [statusLabel, openStatusStackView, closedStatusStackView],
        stackAxis: .horizontal,
        spacing: 30)
    
    
    // MARK: - Properties
    private var isEditingTask: Bool = false {
        didSet {
            navigationItem.title = isEditingTask ? "Edit Task" : "Add Task"
            deleteButton.isHidden = !isEditingTask
        }
    }
    
    // MARK: - Lifecycle
    public init(viewModel: AddEditTodoTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureNavBarItems()
        configureTask()
    }
    
    // MARK: - Actions
    @objc private func radioButtonTapped(_ sender: RadioButton) {
        viewModel.status = sender.tag == 0 ? .open : .closed
        configureTask()
    }
    
    @objc private func saveTask() {
        guard let name = taskNameTextField.text, !name.isEmpty,
              let description = taskDescriptionTextField.text, !description.isEmpty else {
            showAlert(
                with: "Error",
                message: "Name and Description are required fields to enter!",
                actionOneTitle: "OK"
            )
            return
        }
        
        let taskDate = datePicker.date
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        
        viewModel.saveTask(
            name: name,
            description: description,
            status: viewModel.status,
            dateCreated: taskDate,
            taskStartTime: startTime,
            taskEndTime: endTime
        )
    }
    
    @objc private func deleteTask() {
        showAlert(
            with: "Delete",
            message: "Do you want to delete a task?",
            actionOneTitle: "Delete",
            actionTwoTitle: "Canel",
            withHandler: viewModel.deletetask
        )
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
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
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            taskNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            taskNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            taskDescriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            taskDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskDescriptionTextField.heightAnchor.constraint(equalToConstant: 40),
            
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
}

extension AddEditTodoTaskViewController {
    // MARK: - Helpers
    private func showAlert(
        with title: String? = nil,
        message: String,
        actionOneTitle: String,
        actionTwoTitle: String? = nil,
        withHandler completionHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: actionOneTitle,
                          style: .destructive,
                          handler: { _ in
                              completionHandler?()
                          })
        )
        
        if let actionTwoTitle = actionTwoTitle {
            alert.addAction(
                UIAlertAction(title: actionTwoTitle,
                              style: .cancel,
                              handler: { _ in })
            )
        }
        present(alert, animated: true)
    }
    
    private func configureTask() {
        if viewModel.isEditing {
            configureExistingTask()
        } else {
            configureNewTask()
        }
    }
    
    private func selectRadioButton(_ button: RadioButton) {
        openStatusButton.isSelected = (button == openStatusButton)
        closedStatusButton.isSelected = (button == closedStatusButton)
        
        RadioButton.currentlySelectedButton = button
    }
    
    private func configureExistingTask() {
        isEditingTask = true
        
        taskNameTextField.text = viewModel.name
        taskDescriptionTextField.text = viewModel.description
        
        datePicker.date = viewModel.dateCreated
        
        switch viewModel.status {
        case .open:
            selectRadioButton(openStatusButton)
        case .closed:
            selectRadioButton(closedStatusButton)
        }
        
        guard let startTime = viewModel.startTime,
              let endTime = viewModel.endTime else { return }
        startTimePicker.date = startTime
        endTimePicker.date = endTime
    }
    
    private func configureNewTask() {
        isEditingTask = false
        
        taskNameTextField.text = ""
        taskDescriptionTextField.text = ""
        datePicker.date = Date()
        startTimePicker.date = Date()
        endTimePicker.date = Date()
        
        switch viewModel.status {
        case .open:
            selectRadioButton(openStatusButton)
        case .closed:
            selectRadioButton(closedStatusButton)
        }
    }
    
    private static func makeTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 12
        textField.borderStyle = .roundedRect
        return textField
    }
    
    private func configureNavBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTask)
        )
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

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
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    deinit {
        teardownKeyboardNotifications()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureNavBarItems()
        setupKeyboardDismissal()
        configureTask()
    }
    
    // MARK: - Actions
    @objc private func radioButtonTapped(_ sender: RadioButton) {
        viewModel.status = sender.tag == 0 ? .open : .closed
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
        
        guard startTime < endTime else {
            showAlert(
                with: "Error",
                message: "Start time should be less then End time!",
                actionOneTitle: "OK"
            )
            return }
        
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
        
        taskNameTextField.delegate = self
        taskDescriptionTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(taskNameTextField)
        contentView.addSubview(taskDescriptionTextField)
        contentView.addSubview(statusStackView)
        contentView.addSubview(taskDateLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(startTimePicker)
        contentView.addSubview(endTimeLabel)
        contentView.addSubview(endTimePicker)
        contentView.addSubview(deleteButton)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Name Label and TextField constraints
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            taskNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            taskNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Description label and text field
            descriptionLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            taskDescriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            taskDescriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskDescriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskDescriptionTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Status Stack View
            statusStackView.topAnchor.constraint(equalTo: taskDescriptionTextField.bottomAnchor, constant: 30),
            statusStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Date Picker
            taskDateLabel.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 30),
            taskDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            datePicker.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Start Time Picker
            startTimeLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startTimePicker.centerYAnchor.constraint(equalTo: startTimeLabel.centerYAnchor),
            
            startTimePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            startTimePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // End Time Picker
            endTimeLabel.topAnchor.constraint(equalTo: startTimePicker.bottomAnchor, constant: 20),
            endTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            endTimePicker.centerYAnchor.constraint(equalTo: endTimeLabel.centerYAnchor),
            endTimePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            endTimePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Delete Button
            deleteButton.topAnchor.constraint(equalTo: endTimePicker.bottomAnchor, constant: 40),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Ensure contentView bottom is bound properly
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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

// MARK: - Keyboard Notifications
extension AddEditTodoTaskViewController: UITextFieldDelegate {
    //    # Function to return false if the input in UITextFiled is " " or "    ".
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " " || string == "    ") {
            return false
        }
        return true
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func teardownKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

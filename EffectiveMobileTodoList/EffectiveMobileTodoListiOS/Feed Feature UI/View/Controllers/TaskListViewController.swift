//
//  AddEditTasksViewController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

class TaskListViewController: UIViewController {
    
    // MARK: Properties
    private let errorView = ErrorView()
    public var tableModel = [TasksTableCellController]()
    public var addNewTask: (() -> Void)?
    private let customTitleView = CustomTitleHeaderView()
    private let filterView = FiltersView()
    
    // MARK: UI Elements
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return tableView
    }()
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ New Task", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(newTaskTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: Actions
    @objc private func newTaskTapped() {
        addNewTask?()
    }
    
    // MARK: Helpers
    private func setupUI() {
        customTitleView.configure(title: "Today’s Task", subtitle: "Wednesday, 11 May")
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        view.addSubview(filterView)
        view.addSubview(tasksTableView)
        view.addSubview(customTitleView)
        view.addSubview(newTaskButton)
    }
    
    private func setupConstraints() {
        customTitleView.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            customTitleView.trailingAnchor.constraint(lessThanOrEqualTo: newTaskButton.leadingAnchor, constant: -16),
            
            newTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            newTaskButton.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
            newTaskButton.widthAnchor.constraint(equalToConstant: 130),
            newTaskButton.heightAnchor.constraint(equalToConstant: 40),
            
            filterView.topAnchor.constraint(equalTo: customTitleView.bottomAnchor, constant: 16),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterView.heightAnchor.constraint(equalToConstant: 60),
            
            tasksTableView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = cellController(forRowAt: indexPath)
        task.selection()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // MARK - Helpers
    private func cellController(forRowAt indexPath: IndexPath) -> TasksTableCellController {
        return tableModel[indexPath.row]
    }
}

extension TaskListViewController: TaskLoadingView {
    func display(_ viewModel: TaskLoadingViewModel) {
        
    }
}

extension TaskListViewController: TaskErrorView {
    func display(_ viewModel: TaskErrorViewModel) {
        
    }
}

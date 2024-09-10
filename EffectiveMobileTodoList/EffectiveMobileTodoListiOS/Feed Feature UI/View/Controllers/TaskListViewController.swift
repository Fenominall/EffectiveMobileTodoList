//
//  TaskListViewController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

public final class TaskListViewController: UIViewController {
    
    // MARK: Properties
    private(set) public var errorView = ErrorView()
    public var tableModel = [TasksTableCellController]() {
        didSet {
            filterTasks()
            tasksTableView.reloadData()
        }
    }
    private var filteredTasks = [TasksTableCellController]()
    private var selectedFilter: FiltersView.FilterType = .all {
        didSet {
            filterTasks()
        }
    }
    public var addNewTask: (() -> Void)?
    private let customTitleView = CustomTitleHeaderView()
    private let filterView = FiltersView()
    public var onRefresh: (() -> Void)?
    
    // MARK: UI Elements
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        tableView.refreshControl = refreshControl
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
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        refresh()
    }
    
    // MARK: Actions
    @objc private func newTaskTapped() {
        addNewTask?()
    }
    
    @objc private func refresh() {
        onRefresh?()
    }
    
    // MARK: Helpers
    private func setupUI() {
        customTitleView.configure(title: "Today’s Task", subtitle: "Wednesday, 11 May")
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        addSubviews()
        selectFilterTypeAction()
    }
    
    private func addSubviews() {
        [filterView, errorView, tasksTableView, customTitleView, newTaskButton].forEach {
                view.addSubview($0)
            }
    }
    
    private func selectFilterTypeAction() {
        filterView.onFilterSelected = { [weak self] filterType in
            self?.selectedFilter = filterType
        }
    }
    
    private func setupConstraints() {
        customTitleView.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            errorView.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),

            tasksTableView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = cellController(forRowAt: indexPath)
        task.selection()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from filteredTasks and delete the row
            filteredTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()

            filterTasks()

            // Check if the deleted row was the last one
            if filteredTasks.isEmpty {
                // If the last row was deleted, update the indexPath to prevent out-of-range errors
                _ = IndexPath(row: 0, section: 0)
            }

            // Remove the task from the tableModel array
            if let index = tableModel.firstIndex(where: { $0.viewModel.id == filteredTasks[indexPath.row].viewModel.id }) {
                tableModel.remove(at: index)
            }
        }
    }
    
    // MARK - Helpers
    private func cellController(forRowAt indexPath: IndexPath) -> TasksTableCellController {
        return filteredTasks[indexPath.row]
    }
    
    private func filterTasks() {
        let allTasksCount = tableModel.count
        let openTasksCount = tableModel.filter { !$0.viewModel.isCompleted }.count
        let closedTasksCount = tableModel.filter { $0.viewModel.isCompleted }.count
        
        filterView.updateFilterCounts(
            allCount: "\(allTasksCount)",
            openCount: "\(openTasksCount)",
            closedCount: "\(closedTasksCount)"
        )
        
        switch selectedFilter {
        case .all:
            filteredTasks = tableModel
        case .open:
            filteredTasks = tableModel.filter { !$0.viewModel.isCompleted }
        case .closed:
            filteredTasks = tableModel.filter { $0.viewModel.isCompleted }
        }
        
        tasksTableView.reloadData()
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = filteredTasks[indexPath.row]
        if let index = tableModel.firstIndex(where: { $0 === taskToDelete }) {
            tableModel.remove(at: index)
        }
        filteredTasks.remove(at: indexPath.row)
        tasksTableView.deleteRows(at: [indexPath], with: .automatic)
        filterTasks()
    }
}

extension TaskListViewController: TaskLoadingView {
    public func display(_ viewModel: TaskLoadingViewModel) {
        refreshControl.update(isRefreshing: viewModel.isLoading)
    }
}

extension TaskListViewController: TaskErrorView {
    public func display(_ viewModel: TaskErrorViewModel) {
        errorView.message = viewModel.message
    }
}

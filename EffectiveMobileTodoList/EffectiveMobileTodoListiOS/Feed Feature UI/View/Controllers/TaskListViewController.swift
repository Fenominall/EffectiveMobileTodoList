//
//  AddEditTasksViewController.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

class TaskListViewController: UIViewController {
    
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
    
    private let customTitleView = CustomTitleHeaderView()
    private let filterView = FiltersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
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
    
    
    @objc private func newTaskTapped() {
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(
            withName: "Task \(indexPath.row + 1)",
            description: "Crypto Wallet Redesign",
            timeDate: "Today",
            specificTime: "10:00 PM - 11:45 PM",
            isCompleted: indexPath.row % 2 == 0
        )
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        setupRoundedView(with: cell)
    }
    
    private func setupRoundedView(with cell: UITableViewCell) {
        cell.backgroundColor = .clear
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 15
        roundedView.backgroundColor = .white
        roundedView.layer.shadowColor = UIColor.black.cgColor
        roundedView.layer.shadowOpacity = 0.1
        roundedView.layer.shadowOffset = CGSize(width: 0, height: 2)
        roundedView.layer.shadowRadius = 4
        
        cell.contentView.addSubview(roundedView)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.sendSubviewToBack(roundedView)
        
        NSLayoutConstraint.activate([
            roundedView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25),
            roundedView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -25),
            roundedView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            roundedView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
        ])
    }
}


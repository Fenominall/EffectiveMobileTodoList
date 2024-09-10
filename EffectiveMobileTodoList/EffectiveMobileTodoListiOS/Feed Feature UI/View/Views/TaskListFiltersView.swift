//
//  TaskListFiltersView.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

public class FiltersView: UIView {
    private let allButton = TaskListFilterButton(type: .system)
    private let openButton = TaskListFilterButton(type: .system)
    private let closedButton = TaskListFilterButton(type: .system)
    private let divider1 = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTaskListFilterButtons()
        setupDividers()
        setupConstraints()
        
        selectTaskListFilterButton(allButton)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTaskListFilterButtons() {
        allButton.configure(title: "All")
        openButton.configure(title: "Open")
        closedButton.configure(title: "Closed")
        
        allButton.addTarget(self, action: #selector(TaskListFilterButtonTapped), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(TaskListFilterButtonTapped), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(TaskListFilterButtonTapped), for: .touchUpInside)
        
        addSubview(allButton)
        addSubview(openButton)
        addSubview(closedButton)
    }
    
    private func setupDividers() {
        divider1.backgroundColor = .lightGray
        
        addSubview(divider1)
    }
    
    private func setupConstraints() {
        allButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.translatesAutoresizingMaskIntoConstraints = false
        closedButton.translatesAutoresizingMaskIntoConstraints = false
        divider1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            allButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            divider1.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 20),
            divider1.centerYAnchor.constraint(equalTo: centerYAnchor),
            divider1.widthAnchor.constraint(equalToConstant: 1),
            divider1.heightAnchor.constraint(equalToConstant: 18),
            
            openButton.leadingAnchor.constraint(equalTo: divider1.trailingAnchor, constant: 20),
            openButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            closedButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 20),
            closedButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc private func TaskListFilterButtonTapped(_ sender: TaskListFilterButton) {
        selectTaskListFilterButton(sender)
    }
    
    private func selectTaskListFilterButton(_ button: TaskListFilterButton) {
        // Deselect all buttons
        [allButton, openButton, closedButton].forEach { $0.setSelected(false) }
        
        // Select the tapped button
        button.setSelected(true)
    }
    
    public func updateFilterCounts(allCount: String, openCount: String, closedCount: String) {
        allButton.updateCount(allCount)
        openButton.updateCount(openCount)
        closedButton.updateCount(closedCount)
    }
}


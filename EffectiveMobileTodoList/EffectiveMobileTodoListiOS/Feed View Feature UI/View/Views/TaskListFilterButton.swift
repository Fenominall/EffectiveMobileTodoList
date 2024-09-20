//
//  TaskListFilterButton.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

final class TaskListFilterButton: UIButton {
    // MARK: - UI Elements
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textLabel.textColor = .lightGray
        textLabel.alpha = 0.9
        addSubview(textLabel)
        return textLabel
    }()
    
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        countLabel.textColor = .white
        return countLabel
    }()
    
    private lazy var countBackgroundView: UIView = {
        let countBackgroundView = UIView()
        countBackgroundView.layer.cornerRadius = 9
        countBackgroundView.backgroundColor = .lightGray
        countBackgroundView.alpha = 0.5
        countBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countBackgroundView)
        countBackgroundView.addSubview(countLabel)
        return countBackgroundView
    }()
    
    
    // MARK: - Properties
    var isSelectedButton: Bool = false {
        didSet {
            updateUIForSelectionState()
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        updateUIForSelectionState()
    }
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countBackgroundView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 7),
            countBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countBackgroundView.widthAnchor.constraint(equalToConstant: 25),
            countBackgroundView.heightAnchor.constraint(equalToConstant: 18),
            countBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: countBackgroundView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countBackgroundView.centerYAnchor)
        ])
    }
    
    // MARK: - State Update
    private func updateUIForSelectionState() {
        if isSelectedButton {
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            textLabel.textColor = .systemBlue
            countBackgroundView.backgroundColor = .systemBlue
            countBackgroundView.alpha = 1
            countLabel.textColor = .white
        } else {
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            textLabel.textColor = .lightGray
            countBackgroundView.backgroundColor = .lightGray
            countBackgroundView.alpha = 0.5
            countLabel.textColor = .white
        }
    }
    
    // MARK: - Public Methods to Configure the Button
    func configure(title: String) {
        textLabel.text = title
    }
    
    func setSelected(_ selected: Bool) {
        isSelectedButton = selected
    }
    
    func updateCount(_ count: String) {
        countLabel.text = count
    }
}


//
//  TaskTableViewCell.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TaskCell"
    var checkmarkTappedHandler: ((Bool) -> Void)?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let endTimeLabel = UILabel()
    private lazy var checkmarkButton: UIButton = {
        let checkmarkButton = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "circle")
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 22)
        checkmarkButton.configuration = config
        checkmarkButton.tintColor = .systemBlue
        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.imageView?.contentMode = .scaleAspectFit
        checkmarkButton.imageView?.clipsToBounds = true
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        return checkmarkButton
        
    }()
    private let separatorLine = UIView()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.titleLabel, self.descriptionLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.dateLabel, self.startTimeLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    var isTaskCompleted: Bool = false {
        didSet {
            updateCheckmarkState()
            updateCellText()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        
        dateLabel.textColor = .gray
        titleLabel.alpha = 0.7
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        startTimeLabel.textColor = .secondaryLabel
        startTimeLabel.alpha = 0.5
        startTimeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        endTimeLabel.textColor = .secondaryLabel
        endTimeLabel.alpha = 0.5
        endTimeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        separatorLine.backgroundColor = .lightGray
        separatorLine.alpha = 0.3
        
        contentView.addSubview(containerView)
        containerView.addSubview(infoStackView)
        containerView.addSubview(timeStack)
        containerView.addSubview(endTimeLabel)
        containerView.addSubview(checkmarkButton)
        containerView.addSubview(separatorLine)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            
            checkmarkButton.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            checkmarkButton.centerYAnchor.constraint(equalTo: infoStackView.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 22),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 22),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            separatorLine.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 12),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            timeStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            timeStack.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 18),
            endTimeLabel.leadingAnchor.constraint(equalTo: timeStack.trailingAnchor, constant: 5),
            endTimeLabel.centerYAnchor.constraint(equalTo: timeStack.centerYAnchor)
        ])
    }
    
    func configure(
        withName title: String,
        description: String,
        timeDate: String,
        taskStartTime: String?,
        taskEndTime: String?,
        isCompleted: Bool,
        checkmarkTappedHandler: @escaping (Bool) -> Void
    ) {
        self.checkmarkTappedHandler = checkmarkTappedHandler
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = timeDate
        startTimeLabel.text = taskStartTime
        endTimeLabel.text = taskEndTime.flatMap { "- \($0)" } ?? ""
        isTaskCompleted = isCompleted
    }
    
    private func updateCheckmarkState() {
        let imageName = isTaskCompleted ? "checkmark.circle.fill" : "circle"
        checkmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func applyTextAttributes(for completed: Bool) -> [NSAttributedString.Key: Any] {
        return completed ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
    }

    private func updateCellText() {
        let text = titleLabel.text ?? ""
        let attributedText = NSAttributedString(string: text, attributes: applyTextAttributes(for: isTaskCompleted))
        titleLabel.attributedText = attributedText
    }
    
    @objc private func checkmarkTapped() {
        isTaskCompleted.toggle()
        updateCheckmarkState()
        checkmarkTappedHandler?(isTaskCompleted)
    }
}

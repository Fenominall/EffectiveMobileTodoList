//
//  TaskTableViewCell.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/8/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TaskCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timeDateLabel = UILabel()
    private let specificTimeLabel = UILabel()
    private lazy var checkmarkButton: UIButton = {
        let checkmarkButton = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "circle")
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 22)
        checkmarkButton.configuration = config
        checkmarkButton.tintColor = .systemBlue
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
            self.timeDateLabel, self.specificTimeLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    var isTaskCompleted: Bool = false {
        didSet {
            updateCheckmarkState()
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
        contentView.backgroundColor = .clear
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        
        timeDateLabel.textColor = .gray
        titleLabel.alpha = 0.7
        timeDateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        specificTimeLabel.textColor = .secondaryLabel
        specificTimeLabel.alpha = 0.5
        specificTimeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.tintColor = .systemBlue
        checkmarkButton.imageView?.contentMode = .scaleAspectFit
        checkmarkButton.imageView?.clipsToBounds = true
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        
        separatorLine.backgroundColor = .lightGray
        separatorLine.alpha = 0.3
        
        contentView.addSubview(infoStackView)
        contentView.addSubview(timeStack)
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(separatorLine)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeDateLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            
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
        ])
    }
    
    func configure(withName title: String, description: String, timeDate: String, specificTime: String, isCompleted: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        timeDateLabel.text = timeDate
        specificTimeLabel.text = specificTime
        isTaskCompleted = isCompleted
    }
    
    private func updateCheckmarkState() {
        let imageName = isTaskCompleted ? "checkmark.circle.fill" : "circle"
        checkmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        let text = titleLabel.text ?? ""
        let attributedText: NSAttributedString
        
        if isTaskCompleted {
            attributedText = NSAttributedString(string: text, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.label
            ])
        } else {
            attributedText = NSAttributedString(string: text, attributes: [
                .strikethroughStyle: 0,
                .foregroundColor: UIColor.label
            ])
        }
        
        titleLabel.attributedText = attributedText
    }
    
    
    @objc private func checkmarkTapped() {
        isTaskCompleted.toggle()
    }
}

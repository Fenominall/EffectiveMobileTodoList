//
//  UIView+Container.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import UIKit

extension UIView {
    
    public func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        return container
    }
}

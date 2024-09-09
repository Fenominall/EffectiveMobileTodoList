//
//  UIRefreshControl+Helpers.swift .swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/9/24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        return isRefreshing ? beginRefreshing() : endRefreshing()
    }
}

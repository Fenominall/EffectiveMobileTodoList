//
//  TaskRouter.swift
//  EffectiveMobileTodoListiOS
//
//  Created by Fenominall on 9/18/24.
//

import UIKit

public final class AddEditTaskRouter: AddEditTaskNavigationRouter {
    weak var controller: UIViewController?
    
    public init(controller: UIViewController? = nil) {
        self.controller = controller
    }
    
    public func routeToTasksFeed() {
        controller?.navigationController?.popViewController(animated: true)
    }
}

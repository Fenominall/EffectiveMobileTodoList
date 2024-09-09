//
//  TasksFeedUIComposer.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import Foundation
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class TasksFeedUIComposer {
    private init() {}
    
    static func tasksFeedComposedWith(
        feedLoader: TasksLoader,
        selection: @escaping (TodoTask) -> Void
    ) -> TaskListViewController {
        let view = TaskListViewController()
        let interactor = TasksInteractor(
            loader: MainQueueDispatchDecorator(decoratee: feedLoader)
        )
        
        let presenter = TasksPresenter(
            view: WeakRefVirtualProxy(
                TasksFeedViewAdapter(
                    controller: view,
                    selection: selection)),
            errorView: WeakRefVirtualProxy(view),
            loadingView: WeakRefVirtualProxy(view),
            interactor: WeakRefVirtualProxy(interactor)
        )
        
        view.onRefresh = presenter.viewDidLoad
        interactor.presenter = presenter
        
        return view
    }
}

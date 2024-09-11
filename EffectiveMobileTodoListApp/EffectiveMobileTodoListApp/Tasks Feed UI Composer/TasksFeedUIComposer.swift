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
        feedRemover: TasksRemover,
        selection: @escaping (TodoTask) -> Void,
        deleteTask: @escaping (TodoTask) -> Void
    ) -> TaskListViewController {
        let view = TaskListViewController()
        let interactor = TasksInteractor(
            loader: MainQueueDispatchDecorator(decoratee: feedLoader),
            remover: MainQueueDispatchDecorator(decoratee: feedRemover)
        )
        
        let presenter = TasksPresenter(
            view: TasksFeedViewAdapter(
                    controller: view,
                    selection: selection, 
                    onDelete: deleteTask),
            errorView: WeakRefVirtualProxy(view),
            loadingView: WeakRefVirtualProxy(view),
            interactor: interactor
        )
        
        view.onRefresh = presenter.viewDidLoad
        interactor.presenter = presenter
        
        return view
    }
}

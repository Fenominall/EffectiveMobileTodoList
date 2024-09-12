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
        selection: @escaping (TodoTask) -> Void
    ) -> TaskListViewController {
        let view = TaskListViewController()
        let interactor = TasksInteractor(
            loader: MainQueueDispatchDecorator(decoratee: feedLoader),
            remover: MainQueueDispatchDecorator(decoratee: feedRemover)
        )
        
        let viewAdapter = TasksFeedViewAdapter(
            controller: view,
            selection: selection
        )
        
        let presenter = TasksPresenter(
            view: viewAdapter,
            errorView: WeakRefVirtualProxy(view),
            loadingView: WeakRefVirtualProxy(view),
            interactor: interactor
        )
        
        viewAdapter.setOnDeleteHandler { task in
            presenter.didRequestTaskDeletion(task)
        }
        
        view.onRefresh = presenter.viewDidLoad
        interactor.presenter = presenter
        
        return view
    }
}

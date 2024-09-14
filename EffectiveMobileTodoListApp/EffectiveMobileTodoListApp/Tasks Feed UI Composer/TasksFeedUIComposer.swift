//
//  TasksFeedUIComposer.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

final class TasksFeedUIComposer {
    private init() {}
    
    static func tasksFeedComposedWith(
        feedLoader: TasksLoader,
        feedRemover: TasksRemover,
        navigationController: UINavigationController,
        selection: @escaping (TodoTask) -> UIViewController,
        addNeTask: @escaping () -> UIViewController
    ) -> TaskListViewController {
        
        let router = TaskRouter(
            navigationController: navigationController,
            taskDetailComposer: selection,
            addTaskComposer: addNeTask
        )
        let view = TaskListViewController()
        let interactor = TasksInteractor(
            loader: MainQueueDispatchDecorator(decoratee: feedLoader),
            remover: MainQueueDispatchDecorator(decoratee: feedRemover)
        )
        
        let viewAdapter = TasksFeedViewAdapter(
            controller: view,
            selection: { task in
                router.navigateToTaskDetails(for: task)
                return selection(task)
            }
        )
        
        let presenter = TasksPresenter(
            view: viewAdapter,
            errorView: WeakRefVirtualProxy(view),
            loadingView: WeakRefVirtualProxy(view),
            interactor: interactor, 
            router: router
        )
        
        viewAdapter.setOnDeleteHandler { task in
            presenter.didRequestTaskDeletion(task)
        }
        
        view.addNewTask = presenter.didSelectAddNewTask
        view.onRefresh = presenter.viewDidLoad
        interactor.presenter = presenter
        
        return view
    }
}

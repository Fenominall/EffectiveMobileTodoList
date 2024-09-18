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
        taskSaver: TaskSaver,
        navigationController: UINavigationController,
        selection: @escaping (TodoTask) -> UIViewController,
        addNeTask: @escaping () -> UIViewController
    ) -> TaskListViewController {
        
        let router = TasksFeedRouter(
            navigationController: navigationController,
            taskDetailComposer: selection,
            addTaskComposer: addNeTask
        )
        let view = TaskListViewController()
        let interactor = TasksFeedInteractor(
            loader: MainQueueDispatchDecorator(decoratee: feedLoader),
            remover: MainQueueDispatchDecorator(decoratee: feedRemover), 
            taskSaver: MainQueueDispatchDecorator(decoratee: taskSaver)
        )
        
        let viewAdapter = TasksFeedViewAdapter(
            controller: view,
            selection: { task in
                router.navigateToTaskDetails(for: task)
                return selection(task)
            }
        )
        
        let presenter = TasksFeedPresenter(
            view: viewAdapter,
            errorView: WeakRefVirtualProxy(view),
            loadingView: WeakRefVirtualProxy(view),
            interactor: interactor, 
            router: router
        )
        
        viewAdapter.setOnDeleteHandler { [weak presenter] task in
            presenter?.didRequestTaskDeletion(task)
        }
        
        view.addNewTask = presenter.didSelectAddNewTask
        view.onRefresh = presenter.viewDidLoad
        interactor.presenter = presenter
        
        return view
    }
}

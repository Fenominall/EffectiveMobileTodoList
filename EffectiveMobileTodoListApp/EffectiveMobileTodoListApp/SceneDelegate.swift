//
//  SceneDelegate.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/9/24.
//

import UIKit
import EffectiveMobileTodoList
import EffectiveMobileTodoListiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore = {
        do {
            return try CoreDataFeedStore(
                storeURL: CoreDataFeedStore.storeURL
            )
        } catch {
            print("Error instantiating CoreData store: \(error.localizedDescription)")
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var remoteURL = URL(string: "https://dummyjson.com/todos")!
    
    private lazy var launchManager = FirstLaunchManager()
    private lazy var feedLoaderFactory = FeedLoaderFactory(
        httpClient: httpClient,
        store: store,
        remoteURL: remoteURL,
        firstLaunchManager: launchManager)
    
    private let navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    private func configureWindow() {
        let tasksFeedVC = TasksFeedUIComposer.tasksFeedComposedWith(
            feedLoader: feedLoaderFactory.makeFeedLoader(),
            feedRemover: feedLoaderFactory.makeLocalFeedLoader(),
            taskSaver: feedLoaderFactory.makeLocalFeedLoader(),
            navigationController: navigationController,
            selection: {  [weak self] task in
                return self?.taskDetailComposer(task) ?? UIViewController()
                
            }, addNeTask: addTaskComposer
        )
        
        navigationController.viewControllers = [tasksFeedVC]
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    let taskDetailComposer: (TodoTask) -> UIViewController = { task in
        return EditTaskUIComposer.composedWith(selectedModel: task)
    }
    
    private func addTaskComposer() -> UIViewController {
        return AddTaskUIComposer.composedWith()
    }
}

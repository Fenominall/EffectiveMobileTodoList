//
//  FeedLoaderFactory.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/16/24.
//

import Foundation
import EffectiveMobileTodoList

final class FeedLoaderFactory {
    private let httpClient: HTTPClient
    private let store: FeedStore
    private let remoteURL: URL
    private let firstLaunchManager: FirstLaunchManager
    
    init(
        httpClient: HTTPClient,
        store: FeedStore,
        remoteURL: URL,
        firstLaunchManager: FirstLaunchManager
    ) {
        self.httpClient = httpClient
        self.store = store
        self.remoteURL = remoteURL
        self.firstLaunchManager = firstLaunchManager
    }
    
    func makeRemoteFeedLoader() -> RemoteFeedLoader {
        return RemoteFeedLoader(url: remoteURL, client: httpClient)
    }
    
    func makeLocalFeedLoader() -> LocalFeedLoader {
        return LocalFeedLoader(store: store)
    }
    
    func makeFeedLoader() -> TasksLoader {
        let remoteLoader = makeRemoteFeedLoader()
        let localLoader = makeLocalFeedLoader()
        
        if firstLaunchManager.isFirstLaunch() {
            return TasksFeedLoaderWithFallbackComposite(
                primary: makeCacheDecorator(decoratee: remoteLoader),
                fallback: localLoader)
        } else {
            return localLoader
        }
    }
    
    private func makeCacheDecorator(decoratee: TasksLoader) -> TasksFeedLoaderCacheDecorator {
        return TasksFeedLoaderCacheDecorator(decoratee: decoratee, cache: makeLocalFeedLoader())
    }
}

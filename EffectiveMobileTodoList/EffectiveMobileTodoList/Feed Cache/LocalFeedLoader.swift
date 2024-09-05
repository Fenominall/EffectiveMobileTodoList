//
//  LocalFeedLoader.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public final class LocalFeedLoader: TasksLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(
        store: FeedStore,
        currentDate: @escaping () -> Date
    ) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (TasksLoader.Result) -> Void) {
    }
}

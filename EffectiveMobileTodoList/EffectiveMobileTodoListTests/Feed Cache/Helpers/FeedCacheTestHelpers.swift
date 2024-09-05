//
//  FeedCacheTestHelpers.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/5/24.
//

import Foundation
import EffectiveMobileTodoList

func uniqueTodoTask() -> TodoTask {
    TodoTask(
        id: UUID(),
        name: "Name1",
        description: "Description1",
        dateCreated: Date(),
        status: true
    )
}

func uniqueTodoTaskFeed() -> (models: [TodoTask], local: [LocalTodoTask]) {
    let feed = [uniqueTodoTask(), uniqueTodoTask()]
    let localFeedImages = feed.map {
        LocalTodoTask(
            id: $0.id,
            name: $0.name,
            description: $0.description,
            dateCreated: $0.dateCreated,
            status: $0.status
        )
    }
    return (feed, localFeedImages)
}

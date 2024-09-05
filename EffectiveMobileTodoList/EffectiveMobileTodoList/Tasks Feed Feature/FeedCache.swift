//
//  FeedCache.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Swift.Result<Void, Error>
    
    func save(_ feed: [TodoTask], completion: @escaping (SaveResult) -> Void)
}

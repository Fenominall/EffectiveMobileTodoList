//
//  FeedUIUpdateNotifier.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/19/24.
//

import Combine

public final class FeedUIUpdateNotifier {
    private var updateTransactionSubject = PassthroughSubject<Void, Never>()
    
    public var updateTransactionPublisher: AnyPublisher<Void, Never> {
        updateTransactionSubject.eraseToAnyPublisher()
    }

    public func notifyTransactionUpdated() {
        updateTransactionSubject.send(())
    }
}

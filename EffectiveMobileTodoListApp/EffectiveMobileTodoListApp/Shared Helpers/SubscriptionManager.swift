//
//  SubscriptionManager.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/19/24.
//


import Combine

public final class SubscriptionManager {
    public  var cancellables = Set<AnyCancellable>()
    
    func store(_ cancellable: AnyCancellable) {
        cancellable.store(in: &cancellables)
    }
}

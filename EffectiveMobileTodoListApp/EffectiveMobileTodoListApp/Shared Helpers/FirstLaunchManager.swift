//
//  FirstLaunchManager.swift
//  EffectiveMobileTodoListApp
//
//  Created by Fenominall on 9/16/24.
//

import Foundation

final class FirstLaunchManager {
    private let hasLaunchedKey = "hasLaunchedBefore"
    private let userDefaults = UserDefaults.standard
    
    func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = userDefaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunchedBefore {
            userDefaults.setValue(true, forKey: hasLaunchedKey)
            return true
        }
        return false
    }
}

//
//  CacheError.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/5/24.
//

import Foundation

enum CacheError: Error {
    case unableToCreateMutableCopy
    case missingManagedObjectContext
    case taskNotFound
    case taskIDMismatch
}

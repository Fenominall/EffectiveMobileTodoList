//
//  TasksLoader.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/3/24.
//

import Foundation

public protocol TasksLoader {
    typealias Result = Swift.Result<[Task], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

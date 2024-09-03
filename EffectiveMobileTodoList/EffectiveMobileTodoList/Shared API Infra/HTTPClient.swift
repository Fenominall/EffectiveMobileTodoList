//
//  HTTPClient.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/3/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

//
//  SharedTestHelpers.swift
//  EffectiveMobileTodoListTests
//
//  Created by Fenominall on 9/3/24.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "https:any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error",
                   code: 1)
}

func anyData() -> Data {
    return Data("invalid json".utf8)
}

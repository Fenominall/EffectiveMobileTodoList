//
//  HTTPURLResponse+StatusCode.swift
//  EffectiveMobileTodoList
//
//  Created by Fenominall on 9/4/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

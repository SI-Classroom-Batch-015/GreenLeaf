//
//  HTTPError.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import Foundation

enum HTTPError: LocalizedError {
    case invalidURL
    case statusCodeError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .statusCodeError(let code):
            return "The server responded with an error status code: \(code)."
        }
    }
}

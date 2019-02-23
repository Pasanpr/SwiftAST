//
//  Token.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal struct Token {
    let type: TokenType
    let line: Int
    
    public init(type: TokenType, line: Int) {
        self.type = type
        self.line = line
    }
}

extension Token: AutoEquatable {}

extension Token: CustomStringConvertible {
    public var description: String {
        return "\(type)"
    }
}

extension Token {
    var isWhitespace: Bool {
        switch self.type {
        case .whitespace: return true
        default: return false
        }
    }
}

extension Array where Element == Token {
    func strippedWhitespace() -> [Token] {
        let stripped = self.filter { token in
            return !token.isWhitespace
        }
        
        return stripped
    }
}

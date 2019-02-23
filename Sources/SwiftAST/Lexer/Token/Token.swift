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


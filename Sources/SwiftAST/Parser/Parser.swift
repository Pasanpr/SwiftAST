//
//  Parser.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal class Parser {
    private var tokens: [Token]
    
    /// Location of current token
    private var current = 0
    
    /// Returns boolean value to indicate end of file
    private var isAtEnd: Bool {
        return peek().type == .eof
    }
    
    internal init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    internal convenience init() {
        self.init(tokens: [])
    }
    
    // MARK: - Parsing
    
    internal func parse(with tokens: [Token]) throws -> Program {
        self.tokens = tokens
        return try parse()
    }
    
    internal func parse() throws -> Program {
        do {
            let stmt = try statement()
            return Program(statements: [stmt])
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    internal func match(types: TokenType...) -> Bool {
        for type in types {
            if check(type: type) {
                let _ = advance()
                return true
            }
        }
        
        return false
    }
    
    internal func check(type: TokenType) -> Bool {
        if isAtEnd { return false }
        return peek().type == type
    }
    
    internal func advance() -> Token {
        if !isAtEnd { current += 1 }
        return previous()
    }
    
    internal func previous() -> Token {
        return tokens[current - 1]
    }
    
    internal func peek() -> Token {
        return tokens[current]
    }
}

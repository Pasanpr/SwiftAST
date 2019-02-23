//
//  Lexer+Boolean.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal extension Lexer {
    func booleanLiteral(withLexeme lexeme: String) -> Token? {
        switch lexeme {
        case "true": return Token(type: .literal(.boolean(true)), line: line)
        case "false": return Token(type: .literal(.boolean(false)), line: line)
        default: return nil
        }
    }
}

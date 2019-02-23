//
//  Parser+Statements.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

extension Parser {
    internal func statement() throws -> Statement {
        if match(types: .keyword(.declaration(.var))) {
            return try varDeclaration()
        } else if match(types: .keyword(.declaration(.let))) {
            return try letDeclaration()
        } else {
            return try Statement.expression(expression())
        }
    }
    
    internal func varDeclaration() throws -> Statement {
        let identifier = try primary()
        
        // Explicit type declaration
        if match(types: .punctuation(.colon)) {
            let type = try typeDeclaration()
            
            if match(types: .operator(.assignment)) {
                let rhs = try expression()
                return Statement.declaration(.variable(identifier: identifier.description, type: type, expression: rhs))
            } else {
                throw ParserError.expectedVarDeclaration
            }
        } else {
            // Implicit type declaration
            if match(types: .operator(.assignment)) {
                let rhs = try expression()
                return Statement.declaration(.variable(identifier: identifier.description, type: nil, expression: rhs))
            } else {
                throw ParserError.expectedVarDeclaration
            }
        }
    }
    
    internal func letDeclaration() throws -> Statement {
        let identifer = try primary()
        
        if match(types: .punctuation(.colon)) {
            let type = try typeDeclaration()
            
            if match(types: .operator(.assignment)) {
                let rhs = try expression()
                return Statement.declaration(.constant(identifier: identifer.description, type: type, expression: rhs))
            } else {
                throw ParserError.expectedLetDeclaration
            }
        } else {
            // Implicit type declaration
            if match(types: .operator(.assignment)) {
                let rhs = try expression()
                return Statement.declaration(.constant(identifier: identifer.description, type: nil, expression: rhs))
            } else {
                throw ParserError.expectedLetDeclaration
            }
        }
    }
    
    internal func typeDeclaration() throws -> Type {
        let type = peek().type
        
        switch type {
        case .identifier(let name):
            let _ = advance()
            return Type.typeIdentifier(identifier: name)
        default:
            throw ParserError.expectedTypeDeclaration
        }
    }
}

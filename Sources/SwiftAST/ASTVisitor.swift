//
//  ASTVisitor.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/24/19.
//

import Foundation

public protocol ASTVisitor {
    func visit(_ declaration: Declaration) throws -> Bool
    
    // Expressions
    func visit(_ expression: Expression) throws -> Bool
    func visit(_ expression: PrimaryExpression) throws -> Bool
    func visit(_ expression: PrefixExpression) throws -> Bool
    func visit(_ expression: PostfixExpression) throws -> Bool
}

public extension ASTVisitor {
    func traverse(_ program: Program) throws -> Bool {
        return try traverse(program.statements)
    }
    
    func traverse(_ statements: [Statement]) throws -> Bool {
        if statements.isEmpty {
            return false
        }
        
        for stmt in statements {
            guard try traverse(stmt) else { return false }
        }
        
        return true
    }
    
    func traverse(_ statement: Statement) throws -> Bool {
        switch statement {
        case .declaration(let declaration):
            return try traverse(declaration)
        default: fatalError()
        }
    }
    
    func traverse(_ declaration: Declaration) throws -> Bool {
        return try visit(declaration)
    }
}


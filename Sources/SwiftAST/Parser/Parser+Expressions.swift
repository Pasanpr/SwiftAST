//
//  Parser+Expressions.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

extension Parser {
    internal func expression() throws -> Expression {
        return try addition()
    }
    
    // Right associative
    //    private func assignment() throws -> BinaryExpression {
    //
    //        while match(types: .operator(.subtractionAssignment), .operator(.additionAssignment), .operator(.remainderAssignment), .operator(.divisionAssignment), .operator(.multiplicationAssignment), .operator(.assignment)) {
    //            let rhs = try ternary()
    //            return BinaryExpression.assignment(try: nil, rhs: rhs)
    //        }
    //
    //        throw ParserError.expectedAssignmentExpression
    //    }
    //
    //    private func ternary() throws -> BinaryExpression {
    //        return try logicalOr()
    //    }
    //
    //    private func logicalOr() throws -> BinaryExpression {
    //        return try logicalAnd()
    //    }
    //
    //    private func logicalAnd() throws -> BinaryExpression {
    //        return try comparison()
    //    }
    //
    //    private func comparison() throws -> BinaryExpression {
    //        return try nilCoalescing()
    //    }
    //
    //    private func nilCoalescing() throws -> BinaryExpression {
    //        return try casting()
    //    }
    //
    //    private func casting() throws -> BinaryExpression {
    //        return try addition()
    //    }
    
    internal func addition() throws -> Expression {
        let lhs = try multiplication()
        
        while match(types: .operator(.addition), .operator(.subtraction)) {
            let op = previous()
            let rhs = try multiplication()
            return .binary(operator: op, lhs: lhs, rhs: rhs)
        }
        
        return lhs
    }
    
    internal func multiplication() throws -> Expression {
        let lhs = try prefix()
        
        while match(types: .operator(.multiplication), .operator(.division), .operator(.remainder)) {
            let op = previous()
            let rhs = try prefix()
            return Expression.binary(operator: op, lhs: lhs, rhs: rhs)
        }
        
        return lhs
    }
    
    internal func prefix() throws -> Expression {
        if match(types: .operator(.logicalNot)) {
            let op = previous()
            let rhs = try postfix()
            return Expression.prefix(operator: op, rhs: rhs)
        }
        
        return try Expression.prefix(operator: nil, rhs: postfix())
    }
    
    internal func postfix() throws -> PostfixExpression {
        return try PostfixExpression.primary(primary())
    }
    
    internal func primary() throws -> PrimaryExpression {
        let type = peek().type
        
        switch type {
        case .identifier(let name):
            let _ = advance()
            return PrimaryExpression.identifier(name, genericArgs: nil)
        case .literal(let intLiteral):
            let _ = advance()
            return PrimaryExpression.literal(intLiteral)
        case .literal(let stringLiteral):
            let _ = advance()
            return PrimaryExpression.literal(stringLiteral)
        default:
            throw ParserError.expectedPrimaryExpression
        }
    }
}

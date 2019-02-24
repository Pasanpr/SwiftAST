//
//  Expression.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

/*
 Grammar of an Expression
 
 expression -> try-operator(opt) prefix-expression binary-expressions(opt)
 expression-list -> expression | expression , expression-list
 
 GRAMMAR OF A TRY EXPRESSION
 
 try-operator → try | try ? | try !
 */

public enum Expression {
    case prefix(operator: Token?, rhs: PostfixExpression)
    indirect case binary(operator: Token, lhs: Expression, rhs: Expression)
    case primary(PrimaryExpression)
}

extension Expression: AutoEquatable {}

extension Expression {
    var type: Type {
        switch self {
        case .primary(let primaryExpr): return primaryExpr.type
        case .prefix(_, let postfixExpr): return postfixExpr.type
        default: fatalError() // Not implemented
        }
    }
}

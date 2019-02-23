//
//  Prefix.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

/*
 Prefix Expressions
 
 prefix-expression → prefix-operator(opt) postfix-expression
 prefix-expression → in-out-expression
 in-out-expression → & identifier
 */

public enum PrefixExpression {
    case `inout`(identifier: String)
}

extension PrefixExpression: AutoEquatable {}

extension PrefixExpression: CustomStringConvertible {
    public var description: String {
        switch self {
        default: return "fix"
        }
    }
}

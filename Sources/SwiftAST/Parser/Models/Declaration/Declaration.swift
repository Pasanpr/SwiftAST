//
//  Declaration.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

public enum Declaration {
    case variable(identifier: String, type: Type?, expression: Expression)
    case constant(identifier: String, type: Type?, expression: Expression)
}

extension Declaration: AutoEquatable {}

extension Declaration {
    public var identifier: String {
        switch self {
        case .constant(let identifier, _, _):
            return identifier
        case .variable(let identifier, _, _):
            return identifier
        }
    }
    
    public var type: Type? {
        switch self {
        case .variable(_, let type, _): return type
        case .constant(_, let type, _): return type
        }
    }
    
    public var expression: Expression {
        switch self {
        case .constant(_, _, let expression): return expression
        case .variable(_, _, let expression): return expression
        }
    }
}

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

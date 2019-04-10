//
//  ParserError.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal enum ParserError: Error {
    case expectedStatements
    case expectedPrimaryExpression
    case expectedVarDeclaration
    case expectedLetDeclaration
    case expectedTypeDeclaration
    case expectedAssignmentExpression
}

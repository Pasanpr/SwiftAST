//
//  Statement.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

/// Represents a Swift statement
public internal enum Statement {
    case expression(Expression)
    case declaration(Declaration)
    case loopStatement
    case branchStatement
    case labeledStatement
    case controlTransferStatement
    case deferStatement
    case doStatementStatement
    case compilerControlStatement
}

extension Statement: AutoEquatable {}

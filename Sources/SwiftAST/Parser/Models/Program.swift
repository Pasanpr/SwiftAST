//
//  Program.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

internal struct Program {
    let statements: [Statement]
}

extension Program: AutoEquatable {}

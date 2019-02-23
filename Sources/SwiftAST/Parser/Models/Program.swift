//
//  Program.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/22/19.
//

import Foundation

public struct Program {
    let statements: [Statement]
}

extension Program: AutoEquatable {}

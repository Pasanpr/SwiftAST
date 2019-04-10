//
//  ParserTests.swift
//  SwiftASTTests
//
//  Created by Pasan Premaratne on 2/23/19.
//

import XCTest
@testable import SwiftAST

fileprivate extension Statement {
    static var additionStatement: Statement {
        let op = Token(type: .operator(.addition), line: 1)
        let lhs = Expression.prefix(operator: nil, rhs: .primary(.literal(.integer(1))))
        let rhs = Expression.prefix(operator: nil, rhs: .primary(.literal(.integer(2))))
        let expr = Expression.binary(operator: op, lhs: lhs, rhs: rhs)
        
        return Statement.expression(expr)
    }
}

fileprivate extension Program {
    static var implicitVariableDeclaration: Program {
        let stmt = Statement.declaration(.variable(identifier: "foo", type: nil, expression: .prefix(operator: nil, rhs: .primary(.literal(.string("bar"))))))
        return Program(statements: [stmt])
    }
    
    static var explicitVariableDeclaration: Program {
        let stmt = Statement.declaration(.variable(identifier: "foo", type: Type.typeIdentifier(identifier: "String"), expression: .prefix(operator: nil, rhs: .primary(.literal(.string("bar"))))))
        return Program(statements: [stmt])
    }
    
    static var implicitConstantDeclaration: Program {
        let stmt = Statement.declaration(.constant(identifier: "foo", type: nil, expression: .prefix(operator: nil, rhs: .primary(.literal(.string("bar"))))))
        return Program(statements: [stmt])
    }
    
    static var explicitConstantDeclaration: Program {
        let stmt = Statement.declaration(.constant(identifier: "foo", type: Type.typeIdentifier(identifier: "String"), expression: .prefix(operator: nil, rhs: .primary(.literal(.string("bar"))))))
        return Program(statements: [stmt])
    }
}

class ParserTests: XCTestCase {
    
    func testLinuxSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.__allTests.count
        #if swift(>=4.0)
        let darwinCount = thisClass.defaultTestSuite.testCaseCount
        #else
        let darwinCount = Int(thisClass.defaultTestSuite().testCaseCount)
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from __allTests")
        #endif
    }
    
    func testEmptyFile() {
        let tokens = [
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        XCTAssertTrue(program.isEmpty)
    }
    
    func testSingleLineComments() {
        let tokens = [
            Token(type: .whitespace(.comment), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        XCTAssertTrue(program.isEmpty)

    }
    
    func testAdditionExpr() {
        let tokens = [
            Token(type: .literal(.integer(1)), line: 1),
            Token(type: .operator(.addition), line: 1),
            Token(type: .literal(.integer(2)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        XCTAssertTrue(program.statements == [Statement.additionStatement])
    }
    
    func testImplicitVariableDeclaration() {
        // var foo = "bar"
        
        let tokens = [
            Token(type: .keyword(.declaration(.var)), line: 1),
            Token(type: .identifier("foo"), line: 1),
            Token(type: .operator(.assignment), line: 1),
            Token(type: .literal(.string("bar")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        print(program.statements)
        
        XCTAssertTrue(program == Program.implicitVariableDeclaration)
    }
    
    func testExplicitVariableDeclaration() {
        // var foo: String = "bar"
        
        let tokens = [
            Token(type: .keyword(.declaration(.var)), line: 1),
            Token(type: .identifier("foo"), line: 1),
            Token(type: .punctuation(.colon), line: 1),
            Token(type: .identifier("String"), line: 1),
            Token(type: .operator(.assignment), line: 1),
            Token(type: .literal(.string("bar")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        print(program.statements)
        
        XCTAssertTrue(program == Program.explicitVariableDeclaration)
    }
    
    func testImplicitConstantDeclaration() {
        // let foo = "bar"
        
        let tokens = [
            Token(type: .keyword(.declaration(.let)), line: 1),
            Token(type: .identifier("foo"), line: 1),
            Token(type: .operator(.assignment), line: 1),
            Token(type: .literal(.string("bar")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        print(program.statements)
        
        XCTAssertTrue(program == Program.implicitConstantDeclaration)
    }
    
    func testExplicitConstantDeclaration() {
        // let foo: String = "bar"
        
        let tokens = [
            Token(type: .keyword(.declaration(.let)), line: 1),
            Token(type: .identifier("foo"), line: 1),
            Token(type: .punctuation(.colon), line: 1),
            Token(type: .identifier("String"), line: 1),
            Token(type: .operator(.assignment), line: 1),
            Token(type: .literal(.string("bar")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let parser = Parser(tokens: tokens)
        let program = try! parser.parse()
        
        print(program.statements)
        
        XCTAssertTrue(program == Program.explicitConstantDeclaration)
    }
}

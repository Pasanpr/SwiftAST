//
//  TokenTests.swift
//  SwiftASTTests
//
//  Created by Pasan Premaratne on 2/23/19.
//

import XCTest
@testable import SwiftAST

class TokenTests: XCTestCase {
    // MARK: - Single character tokens
    
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
    
    func testEmptyString() {
        let input = ""
        let output: [Token] = [
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSingleSpace() {
        let input = " "
        let output: [Token] = [
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testMultipleSpace() {
        let input = "  "
        let output: [Token] = [
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSingleParen() {
        let input = "("
        let output: [Token] = [
            Token(type: .punctuation(.leftParen), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testMultipleParens() {
        let input = "()"
        let output: [Token] = [
            Token(type: .punctuation(.leftParen), line: 1),
            Token(type: .punctuation(.rightParen), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testParensWithMultipleSpaces() {
        let input = "(  )"
        let output: [Token] = [
            Token(type: .punctuation(.leftParen), line: 1),
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .punctuation(.rightParen), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testBraces() {
        let input = "{}"
        let output: [Token] = [
            Token(type: .punctuation(.leftCurlyBracket), line: 1),
            Token(type: .punctuation(.rightCurlyBracket), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    func testPunctuation() {
        let input = ".,:;"
        let output: [Token] = [
            Token(type: .punctuation(.dot), line: 1),
            Token(type: .punctuation(.comma), line: 1),
            Token(type: .punctuation(.colon), line: 1),
            Token(type: .punctuation(.semicolon), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSlash() {
        let input = "/"
        let output: [Token] = [
            Token(type: .operator(.division), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSingleLineComment() {
        let input = "// This is a comment\n"
        
        let output: [Token] = [
            Token(type: .whitespace(.comment("// This is a comment")), line: 1),
            Token(type: .whitespace(.lineBreak(.newline)), line: 1),
            Token(type: .eof, line: 2)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testLiterals() {
        let stringLiteral = Literal.string("Foo")
        let boolLiteral = Literal.boolean(true)
        let doubleLiteral = Literal.floatingPoint(1.0)
        let intLiteral = Literal.integer(1)
        let interpolatedLiteral = Literal.interpolatedString([
            stringLiteral,
            doubleLiteral
        ])
        
        XCTAssertEqual(stringLiteral.description, "Foo".description)
        XCTAssertEqual(boolLiteral.description, true.description)
        XCTAssertEqual(doubleLiteral.description, 1.0.description)
        XCTAssertEqual(intLiteral.description, 1.description)
        XCTAssertEqual(interpolatedLiteral.description, "\(stringLiteral)\(doubleLiteral)".description)
    }
    
    public func testMultiLineComment() {
        let input = "/* This is a multi line comment.\n\nThat spans a single line.*/"
        
        let output: [Token] = [
            Token(type: .whitespace(.multiLineComment("/* This is a multi line comment.\n\nThat spans a single line.*/")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testDeclaration() {
        let input = "var"
        
        let output: [Token] = [
            Token(type: .keyword(.declaration(.var)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testExpression() {
        let input = "for"
        
        let output: [Token] = [
            Token(type: .keyword(.expression(.for)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testStatement() {
        let input = "nil"
        
        let output: [Token] = [
            Token(type: .keyword(.statement(.nil)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testNumberSignKeyword() {
        let input = "#colorLiteral"
        
        let output: [Token] = [
            Token(type: .keyword(.pound(.colorLiteral)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSingleCharacterOperators() {
        let input = "/=+-*"
        
        let output: [Token] = [
            Token(type: .operator(.divisionAssignment), line: 1),
            Token(type: .operator(.addition), line: 1),
            Token(type: .operator(.subtraction), line: 1),
            Token(type: .operator(.multiplication), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testAssignmentOperator() {
        let input = "="
        
        let output: [Token] = [
            Token(type: .operator(.assignment), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testEqualityOperator() {
        let input = "=="
        
        let output: [Token] = [
            Token(type: .operator(.equalTo), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testIdentityOperator() {
        let input = "==="
        
        let output: [Token] = [
            Token(type: .operator(.identity), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testAdditionAssignment() {
        let input = "+="
        
        let output: [Token] = [
            Token(type: .operator(.additionAssignment), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testSubtractionAssignment() {
        let input = "-="
        
        let output: [Token] = [
            Token(type: .operator(.subtractionAssignment), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testNotEqual() {
        let input = "!="
        
        let output = [
            Token(type: .operator(.notEqualTo), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testNotIdentity() {
        let input = "!=="
        
        let output = [
            Token(type: .operator(.identityNot), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testLessThan() {
        let input = "<"
        
        let output = [
            Token(type: .operator(.lessThan), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testLessThanOrEqual() {
        let input = "<="
        
        let output = [
            Token(type: .operator(.lessThanOrEqual), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testGreaterThan() {
        let input = ">"
        
        let output = [
            Token(type: .operator(.greaterThan), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testGreaterThanOrEqual() {
        let input = ">="
        
        let output = [
            Token(type: .operator(.greaterThanOrEqual), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testNilCoalescing() {
        let input = "??"
        
        let output = [
            Token(type: .operator(.nilCoalescing), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testLogicalAnd() {
        let input = "&&"
        
        let output = [
            Token(type: .operator(.logicalAnd), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testLogicalOr() {
        let input = "||"
        
        let output = [
            Token(type: .operator(.logicalOr), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testHalfOpenRange() {
        let input = "1..<10"
        
        let output = [
            Token(type: .literal(.integer(1)), line: 1),
            Token(type: .operator(.halfOpenRange), line: 1),
            Token(type: .literal(.integer(10)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testClosedRange() {
        let input = "1...10"
        
        let output = [
            Token(type: .literal(.integer(1)), line: 1),
            Token(type: .operator(.closedRange), line: 1),
            Token(type: .literal(.integer(10)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testStringLiteral() {
        let input = "\"This is a string\""
        
        let output = [
            Token(type: .literal(.string("This is a string")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testMultilineStringLiteral() {
        let input = "\"\"\"This is a multiline string literal\"\"\""
        
        let output = [
            Token(type: .literal(.string("This is a multiline string literal")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testInterpolatedStringLiteralInsideSingleLineStringLiteral() {
        let input = "\"This is a string \\(3) after the interpolation\""
        
        let firstLiteral = Literal.string("This is a string ")
        let secondLiteral = Literal.string("3")
        let thirdLiteral = Literal.string(" after the interpolation")
        
        let output = [
            Token(type: .literal(.interpolatedString([firstLiteral, secondLiteral, thirdLiteral])), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testStringInterpolatedStringLiteralInsideSingleLineStringLiteral() {
        let input = "\"This is a string \\(\"3\") after the interpolation\""
        
        let firstLiteral = Literal.string("This is a string ")
        let secondLiteral = Literal.string("3")
        let thirdLiteral = Literal.string(" after the interpolation")
        
        let output = [
            Token(type: .literal(.interpolatedString([firstLiteral, secondLiteral, thirdLiteral])), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testInterpolatedLiteralInsideMultilineStringLiteral() {
        let input = "\"\"\"This is a multiline string literal \\(3) with more string literals\"\"\""
        
        let firstLiteral = Literal.string("This is a multiline string literal ")
        let secondLiteral = Literal.string("3")
        let thirdLiteral = Literal.string(" with more string literals")
        
        let output = [
            Token(type: .literal(.interpolatedString([firstLiteral, secondLiteral, thirdLiteral])), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testBooleanLiteral() {
        let input = "true false"
        
        let output = [
            Token(type: .literal(.boolean(true)), line: 1),
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .literal(.boolean(false)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testIntegerLiteral() {
        let input = "123"
        
        let output: [Token] = [
            Token(type: .literal(.integer(123)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testFloatingPointLiteral() {
        let input = "123.123"
        
        let output: [Token] = [
            Token(type: .literal(.floatingPoint(123.123)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testBasicIdentifier() {
        let input = "foo"
        
        let output = [
            Token(type: .identifier("foo"), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testReservedKeywordAsIdentifier() {
        let input = "`operator`"
        
        let output = [
            Token(type: .identifier("operator"), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testAssignmentExpression() {
        let input = "let name = \"Swift\""
        
        let output = [
            Token(type: .keyword(.declaration(.let)), line: 1),
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .identifier("name"), line: 1),
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .operator(.assignment), line: 1),
            Token(type: .whitespace(.whitespaceItem(.space)), line: 1),
            Token(type: .literal(.string("Swift")), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testQuestionMark() {
        let input = "?"
        
        let output = [
            Token(type: .operator(.optional), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testCast() {
        let input = "as"
        
        let output = [
            Token(type: .keyword(.statement(.as)), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testOptionalCast() {
        let input = "as?"
        
        let output = [
            Token(type: .keyword(.statement(.as)), line: 1),
            Token(type: .operator(.optional), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
    
    public func testExplicitCast() {
        let input = "as!"
        
        let output = [
            Token(type: .keyword(.statement(.as)), line: 1),
            Token(type: .operator(.forcedOptional), line: 1),
            Token(type: .eof, line: 1)
        ]
        
        let lexer = Lexer(source: input)
        XCTAssertEqual(try! lexer.scan(), output)
    }
}

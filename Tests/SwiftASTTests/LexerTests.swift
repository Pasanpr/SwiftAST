//
//  LexerTests.swift
//  SwiftASTTests
//
//  Created by Pasan Premaratne on 2/23/19.
//

import XCTest
@testable import SwiftAST

class LexerTests: XCTestCase {
    
    let source = "var abc = 1"
    
    lazy var lexer: Lexer = {
        return Lexer(source: source)
    }()
    
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
    
    public func testCharacterAtIndexOffsetBy() {
        let first: UnicodeScalar = "v"
        let middle: UnicodeScalar = "b"
        let last: UnicodeScalar = "1"
        
        XCTAssertEqual(lexer.character(in: source, atIndexOffsetBy: 0), first)
        XCTAssertEqual(lexer.character(in: source, atIndexOffsetBy: 5), middle)
        XCTAssertEqual(lexer.character(in: source, atIndexOffsetBy: source.count - 1), last)
    }
    
    public func testAdvanceConsumesCharacterAndMovesForward() {
        XCTAssertTrue(lexer.current == 0)
        let c = lexer.advance()
        XCTAssertTrue(c == UnicodeScalar("v"))
        XCTAssertTrue(lexer.current == 1)
    }
    
    public func testIsDigit() {
        let numbers: [UnicodeScalar] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        for number in numbers {
            XCTAssertTrue(lexer.isDigit(number))
        }
        
        let nonNumbers: [UnicodeScalar] = ["a", "!", "<"]
        
        for nonNumber in nonNumbers {
            XCTAssertFalse(lexer.isDigit(nonNumber))
        }
    }
    
    public func testIsIdentifier() {
        let input: [UnicodeScalar] = ["1"]
        
        for i in input {
            XCTAssertFalse(lexer.isIdentifierHead(i))
        }
    }
    
    public func testIsReservedPunctuation() {
        let input: [UnicodeScalar] = ["?", "!"]
        
        for i in input {
            XCTAssertTrue(lexer.isReservedPunctuation(i))
        }
    }
}

//
//  Lexer.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal final class Lexer {
    private var source: String
    var tokens: Array<Token>
    var start = 0
    public var current = 0
    var line = 1
    
    var isAtEnd: Bool {
        return current >= source.count
    }
    
    convenience init() {
        self.init(source: "")
    }
    
    init(source: String) {
        self.source = source
        self.tokens = []
    }
    
    public func scan(source: String) throws -> [Token] {
        self.source = source
        return try scan()
    }
    
    public func scan() throws -> [Token] {
        while !isAtEnd {
            start = current
            let token = try tokenize()
            tokens.append(token)
        }
        
        let token = Token(type: .eof, line: line)
        tokens.append(token)
        return tokens
    }
    
    private func tokenize() throws -> Token {
        let character = advance()
        switch character {
        case "\n":
            self.line += 1
            return Token(type: .whitespace(.lineBreak(.newline)), line: line - 1)
        case "(", ")", "{", "}":
            return punctuation(character: character, line: line)
        case ".":
            if peek() == "." {
                while peek() == "." && !isAtEnd {
                    let _ = advance()
                }
                
                if match(expected: "<") {
                    return Token(type: .operator(.halfOpenRange), line: line)
                } else {
                    return Token(type: .operator(.closedRange), line: line)
                }
            } else {
                return Token(type: .punctuation(.dot), line: line)
            }
        case ",": return Token(type: .punctuation(.comma), line: line)
        case ":": return Token(type: .punctuation(.colon), line: line)
        case ";": return Token(type: .punctuation(.semicolon), line: line)
        case "/":
            if match(expected: "=") {
                return Token(type: .operator(.divisionAssignment), line: line)
            } else if match(expected: "/") {
                while (peek() != "\n" && !isAtEnd) {
                    let _ = advance()
                }
                
                return Token(type: .whitespace(.comment), line: line)
            } else if match(expected: "*") {
                while (peek() != "*" && peekNext() != "/" && !isAtEnd) {
                    let _ = advance()
                }
                
                // At loop end current points to the last character before the trailing comment marker.
                // Move it forward to the end of the marker
                let _ = advance(by: 2)
                
                let substring = substringInSource(from: start, to: current)
                return Token(type: .whitespace(.multiLineComment(substring)), line: line)
            } else {
                return Token(type: .operator(.division), line: line)
            }
        case " ":
            while (peek() == " " && !isAtEnd) {
                let _ = advance()
            }
            
            return Token(type: .whitespace(.whitespaceItem(.space)), line: line)
        case "=":
            while (peek() == "=" && !isAtEnd) {
                let _ = advance()
            }
            
            let substring = substringInSource(from: start, to: current)
            
            switch substring {
            case "=": return Token(type: .operator(.assignment), line: line)
            case "==": return Token(type: .operator(.equalTo), line: line)
            case "===": return Token(type: .operator(.identity), line: line)
            default:
                throw LexerError.invalidToken
            }
        case "+":
            if match(expected: "=") {
                return Token(type: .operator(.additionAssignment), line: line)
            } else {
                return Token(type: .operator(.addition), line: line)
            }
        case "-":
            if match(expected: "=") {
                return Token(type: .operator(.subtractionAssignment), line: line)
            } else {
                return Token(type: .operator(.subtraction), line: line)
            }
        case "*":
            if match(expected: "=") {
                return Token(type: .operator(.multiplicationAssignment), line: line)
            } else {
                return Token(type: .operator(.multiplication), line: line)
            }
        case "%":
            if match(expected: "=") {
                return Token(type: .operator(.remainderAssignment), line: line)
            } else {
                return Token(type: .operator(.remainder), line: line)
            }
        case "!":
            if match(expected: "=") {
                while (peek() == "=" && !isAtEnd) {
                    let _ = advance()
                }
                
                let substring = substringInSource(from: start, to: current)
                
                switch substring {
                case "!=": return Token(type: .operator(.notEqualTo), line: line)
                case "!==": return Token(type: .operator(.identityNot), line: line)
                default: throw LexerError.invalidToken
                }
            } else if isIdentifierHead(peek()) {
                return Token(type: .operator(.logicalNot), line: line)
            } else {
                return Token(type: .operator(.forcedOptional), line: line)
            }
        case "<":
            if match(expected: "=") {
                return Token(type: .operator(.lessThanOrEqual), line: line)
            } else {
                return Token(type: .operator(.lessThan), line: line)
            }
        case ">":
            if match(expected: "=") {
                return Token(type: .operator(.greaterThanOrEqual), line: line)
            } else {
                return Token(type: .operator(.greaterThan), line: line)
            }
        case "?":
            if match(expected: "?") {
                return Token(type: .operator(.nilCoalescing), line: line)
            } else {
                return Token(type: .operator(.optional), line: line)
            }
        case "&":
            if match(expected: "&") {
                return Token(type: .operator(.logicalAnd), line: line)
            } else {
                fatalError()
            }
        case "|":
            if match(expected: "|") {
                return Token(type: .operator(.logicalOr), line: line)
            } else {
                fatalError()
            }
        case "\"":
            return stringLiteral()
        case "\\":
            // Key Paths
            fatalError()
        case "#":
            while (!isAtEnd && !isWhitespace(peek())) {
                let _ = advance()
            }
            
            let lexeme = substringInSource(from: start, to: current)
            
            if let pound = Keyword.Pound(rawValue: lexeme) {
                return Token(type: .keyword(.pound(pound)), line: line)
            } else {
                fatalError()
            }
        case "`":
            while (!isAtEnd && peek() != "`") {
                let _ = advance()
            }
            
            let lexeme = substringInSource(from: start + 1, to: current)
            
            // Consume closing backtick
            let _ = advance()
            return Token(type: .identifier(lexeme), line: line)
        default:
            if isIdentifierHead(character) {
                while (!isAtEnd && !isReservedPunctuation(peek()) && !isWhitespace(peek())) {
                    let _ = advance()
                }
                
                let lexeme = substringInSource(from: start, to: current)
                
                if let declaration = Keyword.Declaration(rawValue: lexeme) {
                    return Token(type: .keyword(.declaration(declaration)), line: line)
                } else if let expression = Keyword.Expression(rawValue: lexeme) {
                    return Token(type: .keyword(.expression(expression)), line: line)
                } else if let statement = Keyword.Statement(rawValue: lexeme) {
                    return Token(type: .keyword(.statement(statement)), line: line)
                } else if let booleanLiteralToken = booleanLiteral(withLexeme: lexeme) {
                    return booleanLiteralToken
                } else {
                    let firstIndex = lexeme.index(after: lexeme.startIndex)
                    let tail = String(lexeme[firstIndex...])
                    
                    for scalar in tail.unicodeScalars {
                        if !isIdentifierTail(scalar) {
                            fatalError()
                        }
                    }
                    
                    return Token(type: .identifier(lexeme), line: line)
                }
            } else if isDigit(character) {
                if let numericalLiteralToken = numericalLiteral() {
                    return numericalLiteralToken
                } else {
                    throw LexerError.invalidToken
                }
            } else {
                throw LexerError.invalidToken
            }
        }
    }
    
    /// Consume character at `current` position and return it
    ///
    /// Moves current forward after consuming character at `current`
    /// - Returns: UnicodeScalar value at source at position offset by `current`
    public func advance() -> UnicodeScalar {
        // Consume character at current before moving current forward
        let c = character(in: source, atIndexOffsetBy: current)
        current += 1
        return c
    }
    
    public func advance(by i: Int) -> UnicodeScalar {
        let c = character(in: source, atIndexOffsetBy: current)
        current += i
        return c
    }
    
    func peek() -> UnicodeScalar {
        return peek(aheadBy: current)
    }
    
    func peekNext() -> UnicodeScalar {
        return peek(aheadBy: current + 1)
    }
    
    func peek(aheadBy i: Int) -> UnicodeScalar {
        if isAtEnd { return "\0" }
        return character(in: source, atIndexOffsetBy: i)
    }
    
    
    /// Returns true if expected scalar matches scalar at next position
    ///
    /// Functions as a conditional advance. Moves current forward only if match
    /// - Parameter expected: Unicode scalar to match
    /// - Returns: true if match
    private func match(expected: UnicodeScalar) -> Bool {
        if isAtEnd { return false }
        
        if character(in: source, atIndexOffsetBy: current) != expected {
            return false
        }
        
        current += 1
        return true
    }
    
    /// Returns character at specified distance from the start of the source string
    ///
    /// - Parameters:
    ///   - source: The string to scan through
    ///   - offset: The distance to the offset index
    /// - Returns: UnicodeScalar at specified index position
    public func character(in source: String, atIndexOffsetBy offset: Int) -> UnicodeScalar {
        let index = source.unicodeScalars.index(source.unicodeScalars.startIndex, offsetBy: offset)
        return source.unicodeScalars[index]
    }
    
    public func substringInSource(from start: Int, to end: Int) -> String {
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: end)
        return String(source[startIndex..<endIndex])
    }
    
    public func isKeyword(_ c: UnicodeScalar) -> Bool {
        let letters = CharacterSet.uppercaseLetters.union(.lowercaseLetters)
        let underscoreSet = CharacterSet(charactersIn: "#")
        let combinedSet = letters.union(underscoreSet)
        return combinedSet.contains(c)
    }
    
    
    public func isWhitespace(_ c: UnicodeScalar) -> Bool {
        let set = CharacterSet.whitespacesAndNewlines
        return set.contains(c)
    }
    
    public func isReservedPunctuation(_ c: UnicodeScalar) -> Bool {
        var set = CharacterSet()
        set.insert(charactersIn: "!?")
        return set.contains(c)
    }
}


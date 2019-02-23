//
//  Punctuation.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

internal enum Punctuation: String,  AutoEquatable {
    case leftParen = "\u{0028}"
    case rightParen = "\u{0029}"
    case leftCurlyBracket = "\u{007B}"
    case rightCurlyBracket = "\u{007D}"
    case leftSquareBracket = "\u{005B}"
    case rightSquareBracket = "\u{005D}"
    case dot = "\u{002E}"
    case comma = "\u{002C}"
    case colon = "\u{003A}"
    case semicolon = "\u{003B}"
}

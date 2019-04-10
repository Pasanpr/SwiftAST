//
//  Whitespace.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/23/19.
//

import Foundation

extension TokenType.Whitespace: AutoEquatable {}

extension TokenType.Whitespace: CustomStringConvertible {
    public var description: String {
        switch self {
        case .comment: return "//"
        case .lineBreak(let linebreak):
            switch linebreak {
            case .carriageReturn: return "\\r"
            case .newline: return "\\n"
            }
        case .whitespaceItem(let whitespaceItem):
            switch whitespaceItem {
            case .null: return "null"
            case .horizontalTab: return "\\t"
            case .verticalTab: return "\\t"
            case .formFeed: return "\\f"
            case .space: return " "
            }
        case .multiLineComment(let comment): return comment
        }
    }
}

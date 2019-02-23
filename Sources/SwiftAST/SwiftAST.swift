import Foundation

public class SwiftAST {
    private let source: String
    
    public convenience init() throws {
        try self.init(contentsOfFile: "")
    }
    
    public init(contentsOfFile source: String) throws {
        self.source = source
    }
    
    public init(pathToFile path: String) {
        fatalError("Not implemented")
    }
    
    public func generateAST() throws -> Program {
        let lexer = Lexer(source: self.source)
        let parser = try Parser(tokens: tokenize(using: lexer))
        return try parser.parse()
    }
    
    private func tokenize(using lexer: Lexer) throws -> [Token] {
        let tokens = try lexer.scan()
        return tokens.strippedWhitespace()
    }
}

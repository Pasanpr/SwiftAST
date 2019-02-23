import Foundation

public class SwiftAST {
    let program: Program
    
    public init(source: String) throws {
        let parser = Parser(contentsOfFile: source)
        self.program = try parser.generateAST()
    }
}

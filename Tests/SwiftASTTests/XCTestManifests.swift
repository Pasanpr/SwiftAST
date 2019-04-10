import XCTest

extension LexerTests {
    static let __allTests = [
        ("testAdvanceConsumesCharacterAndMovesForward", testAdvanceConsumesCharacterAndMovesForward),
        ("testCharacterAtIndexOffsetBy", testCharacterAtIndexOffsetBy),
        ("testIsDigit", testIsDigit),
        ("testIsIdentifier", testIsIdentifier),
        ("testIsReservedPunctuation", testIsReservedPunctuation),
        ("testLinuxSuiteIncludesAllTests", testLinuxSuiteIncludesAllTests),
    ]
}

extension ParserTests {
    static let __allTests = [
        ("testEmptyFile", testEmptyFile),
        ("testSingleLineComments", testSingleLineComments),
        ("testAdditionExpr", testAdditionExpr),
        ("testExplicitConstantDeclaration", testExplicitConstantDeclaration),
        ("testExplicitVariableDeclaration", testExplicitVariableDeclaration),
        ("testImplicitConstantDeclaration", testImplicitConstantDeclaration),
        ("testImplicitVariableDeclaration", testImplicitVariableDeclaration),
        ("testLinuxSuiteIncludesAllTests", testLinuxSuiteIncludesAllTests),
    ]
}

extension TokenTests {
    static let __allTests = [
        ("testAdditionAssignment", testAdditionAssignment),
        ("testAssignmentExpression", testAssignmentExpression),
        ("testAssignmentOperator", testAssignmentOperator),
        ("testBasicIdentifier", testBasicIdentifier),
        ("testBooleanLiteral", testBooleanLiteral),
        ("testBraces", testBraces),
        ("testCast", testCast),
        ("testClosedRange", testClosedRange),
        ("testDeclaration", testDeclaration),
        ("testEmptyString", testEmptyString),
        ("testEqualityOperator", testEqualityOperator),
        ("testExplicitCast", testExplicitCast),
        ("testExpression", testExpression),
        ("testFloatingPointLiteral", testFloatingPointLiteral),
        ("testGreaterThan", testGreaterThan),
        ("testGreaterThanOrEqual", testGreaterThanOrEqual),
        ("testHalfOpenRange", testHalfOpenRange),
        ("testIdentityOperator", testIdentityOperator),
        ("testIntegerLiteral", testIntegerLiteral),
        ("testInterpolatedLiteralInsideMultilineStringLiteral", testInterpolatedLiteralInsideMultilineStringLiteral),
        ("testInterpolatedStringLiteralInsideSingleLineStringLiteral", testInterpolatedStringLiteralInsideSingleLineStringLiteral),
        ("testLessThan", testLessThan),
        ("testLessThanOrEqual", testLessThanOrEqual),
        ("testLinuxSuiteIncludesAllTests", testLinuxSuiteIncludesAllTests),
        ("testLiterals", testLiterals),
        ("testLogicalAnd", testLogicalAnd),
        ("testLogicalOr", testLogicalOr),
        ("testMultiLineComment", testMultiLineComment),
        ("testMultilineStringLiteral", testMultilineStringLiteral),
        ("testMultipleParens", testMultipleParens),
        ("testMultipleSpace", testMultipleSpace),
        ("testNilCoalescing", testNilCoalescing),
        ("testNotEqual", testNotEqual),
        ("testNotIdentity", testNotIdentity),
        ("testNumberSignKeyword", testNumberSignKeyword),
        ("testOptionalCast", testOptionalCast),
        ("testParensWithMultipleSpaces", testParensWithMultipleSpaces),
        ("testPunctuation", testPunctuation),
        ("testQuestionMark", testQuestionMark),
        ("testReservedKeywordAsIdentifier", testReservedKeywordAsIdentifier),
        ("testSingleCharacterOperators", testSingleCharacterOperators),
        ("testSingleLineComment", testSingleLineComment),
        ("testSingleParen", testSingleParen),
        ("testSingleSpace", testSingleSpace),
        ("testSlash", testSlash),
        ("testStatement", testStatement),
        ("testStringInterpolatedStringLiteralInsideSingleLineStringLiteral", testStringInterpolatedStringLiteralInsideSingleLineStringLiteral),
        ("testStringLiteral", testStringLiteral),
        ("testSubtractionAssignment", testSubtractionAssignment),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LexerTests.__allTests),
        testCase(ParserTests.__allTests),
        testCase(TokenTests.__allTests),
    ]
}
#endif

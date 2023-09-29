import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


///
#if canImport(PublicInit_packageMacros)
import PublicInit_packageMacros

let testMacros: [String: Macro.Type] = [
    "PublicInit": PublicInitMacro.self,
]
#endif

final class PublicInit_packageTests: XCTestCase {
    func testMacro() throws {
        #if canImport(PublicInit_packageMacros)
        assertMacroExpansion(
            """
            @PublicInit
            public struct Foo {
                public var bar: Int
                public var baz: Bool
            }
            """,
            expandedSource: """
            public struct Foo {
                public var bar: Int
                public var baz: Bool
            
                public init (bar: Int, baz: Bool) {
                    self.bar = bar
                    self.baz = baz
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

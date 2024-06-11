import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import MacroTesting

#if canImport(MacrosTalkMacros)
import MacrosTalkMacros
#endif

@Suite("Cased Macro")
struct CasedTests {
    @Test("Generates properties and boolean for each case")
    func testCased() async throws {

    }
}

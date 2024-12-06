import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import MacroTesting

#if canImport(MacrosTalkMacros)
import MacrosTalkMacros
#endif

@Suite
struct CasedTests {
    @Test("@Cased on enum")
    func testCased() async throws {

    }
}

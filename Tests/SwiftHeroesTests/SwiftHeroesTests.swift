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
        assertMacro(["Cased": CasedMacro.self]) {
        """
        @Cased
        enum Membership {
            case nonMember
            case user(User, Team)
            case team(Team)
            case company(Company)
        }
        """
        } expansion: {
        """
        enum Membership {
            case nonMember
            case user(User, Team)
            case team(Team)
            case company(Company)

            var isNonMember: Bool {
                if case .nonMember = self {
                    return true
                }
                return false
            }

            var isUser: Bool {
                if case .user = self {
                    return true
                }
                return false
            }

            var user: (User, Team)? {
                guard case let .user(e0, e1) = self else {
                    return nil
                }

                return (e0, e1)
            }

            var isTeam: Bool {
                if case .team = self {
                    return true
                }
                return false
            }

            var team: Team? {
                guard case let .team(element) = self else {
                    return nil
                }

                return element
            }

            var isCompany: Bool {
                if case .company = self {
                    return true
                }
                return false
            }

            var company: Company? {
                guard case let .company(element) = self else {
                    return nil
                }

                return element
            }
        }
        """
        }
    }

    @Test("Macro attached to non-enum type")
    func testNotAnEnum() async throws {
        assertMacro(["Cased": CasedMacro.self]) {
        """
        @Cased
        struct NotAnEnum {}
        """
        } diagnostics: {
        """
        @Cased
        ┬─────
        ╰─ 🛑 @Cased can only be attached to enums
        struct NotAnEnum {}
        """
        }
    }
}

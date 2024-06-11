import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CasedMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw Error.notAnEnum
        }

        let caseDecls = enumDecl.memberBlock.members
            .compactMap {
                $0.decl.as(EnumCaseDeclSyntax.self)?
                    .elements
                    .first
            }

        return caseDecls.flatMap { caseDecl in
            let name = caseDecl.name
            let textName = name.text
            let camelName = textName[textName.startIndex].uppercased() + textName.dropFirst()

            var output: [DeclSyntax] = [
                """
                var is\(raw: camelName): Bool {
                    if case .\(name) = self { return true }
                    return false
                }
                """
            ]

            let associatedTypes = caseDecl.associatedTypes

            switch associatedTypes.count {
            case 1:
                let type = associatedTypes[0]
                output.append(
                    """
                    var \(name): \(type)? {
                        guard case let .\(name)(element) = self else {
                            return nil
                        }

                        return element
                    }
                    """
                )
            case 2:
                let tuple = associatedTypes.map(\.text).joined(separator: ", ")
                let args = associatedTypes.enumerated()
                    .map { idx, _ in "e\(idx)" }
                    .joined(separator: ", ")
                
                output.append(
                    """
                    var \(name): (\(raw: tuple))? {
                        guard case let .\(name)(\(raw: args)) = self else {
                            return nil
                        }

                        return (\(raw: args))
                    }
                    """
                )
            default:
                break
            }

            return output
        }
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case notAnEnum

        var description: String {
            switch self {
            case .notAnEnum:
                "@Cased can only be attached to enums"
            }
        }
    }
}

private extension EnumCaseElementSyntax {
    var associatedTypes: [TokenSyntax] {
        parameterClause?.parameters
            .compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name } ?? []
    }
}

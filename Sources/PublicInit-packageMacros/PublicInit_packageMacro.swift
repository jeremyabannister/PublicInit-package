import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


///
enum PublicInitError: CustomStringConvertible, Error {
    
    ///
    case onlyApplicableToStruct
    
    ///
    var description: String {
        switch self {
        case .onlyApplicableToStruct: return "@PublicInit can only be applied to a structure"
        }
    }
}

///
public struct PublicInitMacro: MemberMacro {
    
    ///
    public static func expansion
        (of node: AttributeSyntax,
         providingMembersOf declaration: some DeclGroupSyntax,
         in context: some MacroExpansionContext)
    throws -> [SwiftSyntax.DeclSyntax] {
        
        ///
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw PublicInitError.onlyApplicableToStruct
        }
        
        ///
        let members = structDecl.memberBlock.members
        let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let variablesName = variableDecl.compactMap { $0.bindings.first?.pattern }
        let variablesType = variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }
        
        ///
        let initializer =
            try InitializerDeclSyntax(
                PublicInitMacro
                    .generateInitialCode(
                        variablesName: variablesName,
                        variablesType: variablesType
                    ),
                bodyBuilder: {
                    for name in variablesName {
                        ExprSyntax("self.\(name) = \(name)")
                    }
                }
            )
        
        ///
        return [DeclSyntax(initializer)]
    }
    
    ///
    public static func generateInitialCode
        (variablesName: [PatternSyntax],
         variablesType: [TypeSyntax])
    -> SyntaxNodeString {
        
        ///
        var initialCode: String = "public init ("
        for (name, type) in zip(variablesName, variablesType) {
            initialCode += "\(name): \(type), "
        }
        initialCode = String(initialCode.dropLast(2))
        initialCode += ")"
        return SyntaxNodeString(stringLiteral: initialCode)
    }
}

@main
struct PublicInit_packagePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PublicInitMacro.self,
    ]
}

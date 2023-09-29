
///
@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "PublicInit-packageMacros", type: "PublicInitMacro")

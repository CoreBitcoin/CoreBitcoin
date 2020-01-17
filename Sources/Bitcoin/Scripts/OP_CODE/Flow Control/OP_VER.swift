import Foundation

public struct OpVer: OpCodeProtocol {
    public var value: UInt8 { return 0x62 }
    public var name: String { return "OP_VER" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_VER should not be executed.")
    }
}

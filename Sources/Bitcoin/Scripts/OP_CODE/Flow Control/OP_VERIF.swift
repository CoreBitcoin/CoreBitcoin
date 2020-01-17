import Foundation

// Transaction is invalid unless occuring in an unexecuted OP_IF branch
public struct OpVerIf: OpCodeProtocol {
    public var value: UInt8 { return 0x65 }
    public var name: String { return "OP_VERIF" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_VERIF should not be executed.")
    }
}

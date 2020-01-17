import Foundation

public struct OpInvalidOpCode: OpCodeProtocol {
    public var value: UInt8 { return 0xff }
    public var name: String { return "OP_INVALIDOPCODE" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_INVALIDOPCODE should not be executed.")
    }
}

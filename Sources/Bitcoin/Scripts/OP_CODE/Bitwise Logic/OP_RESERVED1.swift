import Foundation

public struct OpReserved1: OpCodeProtocol {
    public var value: UInt8 { return 0x89 }
    public var name: String { return "OP_RESERVED1" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("\(name) should not be executed.")
    }
}

import Foundation

public struct OpReserved: OpCodeProtocol {
    public var value: UInt8 { return 0x50 }
    public var name: String { return "OP_RESERVED" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("\(name) should not be executed.")
    }
}

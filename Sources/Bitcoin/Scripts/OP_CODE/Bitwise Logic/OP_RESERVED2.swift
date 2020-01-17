import Foundation

public struct OpReserved2: OpCodeProtocol {
    public var value: UInt8 { return 0x8a }
    public var name: String { return "OP_RESERVED2" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("\(name) should not be executed.")
    }
}

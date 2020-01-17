import Foundation

public struct OpReturn: OpCodeProtocol {
    public var value: UInt8 { return 0x6a }
    public var name: String { return "OP_RETURN" }

     public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_RETURN was encountered")
    }
}

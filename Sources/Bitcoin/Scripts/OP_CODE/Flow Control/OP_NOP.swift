import Foundation

// do nothing
public struct OpNop: OpCodeProtocol {
    public var value: UInt8 { return 0x61 }
    public var name: String { return "OP_NOP" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

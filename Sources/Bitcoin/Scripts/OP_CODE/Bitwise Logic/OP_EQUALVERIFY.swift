import Foundation

// Same as OP_EQUAL, but runs OP_VERIFY afterward.
public struct OpEqualVerify: OpCodeProtocol {
    public var value: UInt8 { return 0x88 }
    public var name: String { return "OP_EQUALVERIFY" }

    // input : x1 x2
    // output : - / fail
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try OpCode.OP_EQUAL.mainProcess(context)
        do {
            try OpCode.OP_VERIFY.mainProcess(context)
        } catch {
            throw OpCodeExecutionError.error("OP_EQUALVERIFY failed.")
        }
    }
}

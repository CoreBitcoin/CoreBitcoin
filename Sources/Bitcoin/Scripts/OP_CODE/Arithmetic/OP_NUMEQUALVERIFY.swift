import Foundation

// Same as OP_NUMEQUAL, but runs OP_VERIFY afterward.
public struct OpNumEqualVerify: OpCodeProtocol {
    public var value: UInt8 { return 0x9d }
    public var name: String { return "OP_NUMEQUALVERIFY" }

    // input : x1 x2
    // output : - / fail
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try OpCode.OP_NUMEQUAL.mainProcess(context)
        do {
            try OpCode.OP_VERIFY.mainProcess(context)
        } catch {
            throw OpCodeExecutionError.error("OP_NUMEQUALVERIFY failed.")
        }
    }
}

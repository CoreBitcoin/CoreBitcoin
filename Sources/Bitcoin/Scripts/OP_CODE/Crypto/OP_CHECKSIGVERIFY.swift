import Foundation

// Same as OP_CHECKSIG, but OP_VERIFY is executed afterward.
public struct OpCheckSigVerify: OpCodeProtocol {
    public var value: UInt8 { return 0xad }
    public var name: String { return "OP_CHECKSIGVERIFY" }

    // input : sig pubkey
    // output : Nothing / fail
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try OpCode.OP_CHECKSIG.mainProcess(context)
        do {
            try OpCode.OP_VERIFY.mainProcess(context)
        } catch {
            throw OpCodeExecutionError.error("OP_CHECKSIGVERIFY failed.")
        }
    }
}

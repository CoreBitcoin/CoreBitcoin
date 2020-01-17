import Foundation

// Same as OP_CHECKMULTISIG, but OP_VERIFY is executed afterward.
public struct OpCheckMultiSigVerify: OpCodeProtocol {
    public var value: UInt8 { return 0xaf }
    public var name: String { return "OP_CHECKMULTISIGVERIFY" }

    // input : x sig1 sig2 ... <number of signatures> pub1 pub2 <number of public keys>
    // output : Nothing / fail
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try OpCode.OP_CHECKMULTISIG.mainProcess(context)
        do {
            try OpCode.OP_VERIFY.mainProcess(context)
        } catch {
            throw OpCodeExecutionError.error("OP_CHECKMULTISIGVERIFY failed.")
        }
    }
}

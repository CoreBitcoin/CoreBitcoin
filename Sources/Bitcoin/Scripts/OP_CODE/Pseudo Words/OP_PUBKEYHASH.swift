import Foundation

// Represents a public key compatible with OP_CHECKSIG.
// This is used internally for assisting with transaction matching. They are invalid if used in actual scripts.
public struct OpPubkeyHash: OpCodeProtocol {
    public var value: UInt8 { return 0xfd }
    public var name: String { return "OP_PUBKEYHASH" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_PUBKEYHASH should not be executed.")
    }
}

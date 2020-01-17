import Foundation

// Represents a public key hashed with OP_HASH160.
// This is used internally for assisting with transaction matching. They are invalid if used in actual scripts.
public struct OpPubkey: OpCodeProtocol {
    public var value: UInt8 { return 0xfe }
    public var name: String { return "OP_PUBKEY" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        throw OpCodeExecutionError.error("OP_PUBKEY should not be executed.")
    }
}

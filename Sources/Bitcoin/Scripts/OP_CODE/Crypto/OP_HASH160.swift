import Foundation

// The input is hashed twice: first with SHA-256 and then with RIPEMD-160.
public struct OpHash160: OpCodeProtocol {
    public var value: UInt8 { return 0xa9 }
    public var name: String { return "OP_HASH160" }

    // input : in
    // output : hash
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let data: Data = context.stack.removeLast()
        let hash: Data = Crypto.sha256ripemd160(data)
        context.stack.append(hash)
    }
}

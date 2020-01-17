import Foundation

// An empty array of bytes is pushed onto the stack.
// This is not a no-op, but is PUSHDATA op: an item is added to the stack.
//
public struct Op0: OpCodeProtocol {
    public var value: UInt8 { return 0x00 }
    public var name: String { return "OP_0" }
}

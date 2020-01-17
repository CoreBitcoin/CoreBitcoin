import Foundation
// Any opcode with value < PUSHDATA1 is a length of the string to be pushed on the stack.
// So opcode 0x01 is followed by 1 byte of data, 0x09 by 9 bytes and so on up to 0x4b (75 bytes)
// PUSHDATA<N> opcode is followed by N-byte length of the string that follows.

// The next 1-byte contains the number of bytes to be pushed onto the stack (allows pushing 0..255 bytes).
public struct OpPushData1: OpCodeProtocol {
    public var value: UInt8 { return 0x4c }
    public var name: String { return "OP_PUSHDATA1" }
}

// The next 2-bytes contain the number of bytes to be pushed onto the stack in little endian order (allows pushing 0..65535 bytes).
public struct OpPushData2: OpCodeProtocol {
    public var value: UInt8 { return 0x4d }
    public var name: String { return "OP_PUSHDATA2" }
}

// The next 4-bytes contain the number of bytes to be pushed onto the stack in little endian order (allows pushing 0..4294967295 bytes)
public struct OpPushData4: OpCodeProtocol {
    public var value: UInt8 { return 0x4e }
    public var name: String { return "OP_PUSHDATA4" }
}

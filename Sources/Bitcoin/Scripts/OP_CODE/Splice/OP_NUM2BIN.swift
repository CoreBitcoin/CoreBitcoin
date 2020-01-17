import Foundation

// convert numeric value a into byte sequence of length b
public struct OpNum2Bin: OpCodeProtocol {
    public var value: UInt8 { return 0x80 }
    public var name: String { return "OP_NUM2BIN" }

}

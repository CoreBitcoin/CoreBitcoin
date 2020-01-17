import Foundation

// convert byte sequence x into a numeric value
public struct OpBin2Num: OpCodeProtocol {
    public var value: UInt8 { return 0x81 }
    public var name: String { return "OP_BIN2NUM" }

}

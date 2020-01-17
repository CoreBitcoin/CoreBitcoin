import Foundation

/**
 This struct represents a factory that creates OpCodes from integers or strings.
 */
public struct OpCodeFactory {

    /**
     Returns the OpCode which a given UInt8 value.
     Returns OP_INVALIDOPCODE for outranged value.
     
     - parameter value: UInt8 value corresponding to the OpCode
     
     - returns: The OpCode corresponding to value
    */
    public static func get(with value: UInt8) -> OpCode {
        guard let item = (OpCode.list.first { $0.value == value }) else {
            return .OP_INVALIDOPCODE
        }
        return item
    }

    /**
     Returns the OpCode which a given name.
     Returns OP_INVALIDOPCODE for unknown names.
     
     - parameter name: String corresponding to the OpCode
     
     - returns: The OpCode corresponding to name
     */
    public static func get(with name: String) -> OpCode {
        guard let item = (OpCode.list.first { $0.name == name }) else {
            return .OP_INVALIDOPCODE
        }
        return item
    }

    /**
     Returns OP_1NEGATE, OP_0 .. OP_16 for ints from -1 to 16.
     Returns OP_INVALIDOPCODE for other ints.
     
     - parameter smallInteger: Int value from -1 to 16
 
     - returns: The OpCode corresponding to smallInteger
    */
    public typealias SmallInteger = Int
    public static func opcode(for smallInteger: SmallInteger) -> OpCode {
        switch smallInteger {
        case -1:
            return .OP_1NEGATE
        case 0:
            return .OP_0
        case 1...16:
            return get(with: OpCode.OP_1.value + UInt8(smallInteger - 1))
        default:
            return .OP_INVALIDOPCODE
        }
    }

    /**
     Converts opcode OP_<N> or OP_1NEGATE to an Int value.
     If incorrect opcode is given, Int.max is returned.
     
     - parameter opcode: OpCode which can be OP_<N> or OP_1NEGATE
     
     - returns: Int value correspondint to OpCode
    */
    public static func smallInteger(from opcode: OpCode) -> SmallInteger {
        switch opcode {
        case .OP_1NEGATE:
            return -1
        case .OP_0:
            return 0
        case (OpCode.OP_1)...(OpCode.OP_16):
            return Int(opcode.value - OpCode.OP_1.value + 1)
        default:
            return Int.max
        }
    }
}

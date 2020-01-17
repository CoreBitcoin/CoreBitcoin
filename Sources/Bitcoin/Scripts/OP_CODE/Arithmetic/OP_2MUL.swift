import Foundation

// The input is multiplied by 2. disabled.
public struct Op2Mul: OpCodeProtocol {
    public var value: UInt8 { return 0x8d }
    public var name: String { return "OP_2MUL" }

    public func isEnabled() -> Bool {
        return false
    }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(input * 2)
    }
}

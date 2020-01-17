import Foundation

// replaces number with its absolute value
public struct OpAbsolute: OpCodeProtocol {
    public var value: UInt8 { return 0x90 }
    public var name: String { return "OP_ABS" }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(abs(input))
    }
}

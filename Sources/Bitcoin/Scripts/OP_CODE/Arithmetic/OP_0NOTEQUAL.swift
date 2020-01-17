import Foundation

// replaces number with True if it's not zero, False otherwise.
public struct OP0NotEqual: OpCodeProtocol {
    public var value: UInt8 { return 0x92 }
    public var name: String { return "OP_0NOTEQUAL" }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        context.pushToStack(input != 0)
    }
}

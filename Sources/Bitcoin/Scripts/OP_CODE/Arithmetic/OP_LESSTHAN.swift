import Foundation

// Returns 1 if x1 is less than x2, 0 otherwise.
public struct OpLessThan: OpCodeProtocol {
    public var value: UInt8 { return 0x9f }
    public var name: String { return "OP_LESSTHAN" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        context.pushToStack(x1 < x2)
    }
}

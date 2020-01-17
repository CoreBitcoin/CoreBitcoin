import Foundation

// Returns 1 if x1 is greater than or equal to x2, 0 otherwise.
public struct OpGreaterThanOrEqual: OpCodeProtocol {
    public var value: UInt8 { return 0xa2 }
    public var name: String { return "OP_GREATERTHANOREQUAL" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        context.pushToStack(x1 >= x2)
    }
}

import Foundation

// Returns the larger of a and b.
public struct OpMax: OpCodeProtocol {
    public var value: UInt8 { return 0xa4 }
    public var name: String { return "OP_MAX" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        try context.pushToStack(max(x1, x2))
    }
}

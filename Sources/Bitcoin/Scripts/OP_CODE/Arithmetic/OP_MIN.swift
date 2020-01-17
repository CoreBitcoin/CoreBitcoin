import Foundation

// Returns the smaller of a and b.
public struct OpMin: OpCodeProtocol {
    public var value: UInt8 { return 0xa3 }
    public var name: String { return "OP_MIN" }

    // (x1 x2 -- out)
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        try context.pushToStack(min(x1, x2))
    }
}

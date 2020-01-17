import Foundation

// Returns 1 if x is within the specified range (left-inclusive), 0 otherwise.
public struct OpWithin: OpCodeProtocol {
    public var value: UInt8 { return 0xa5 }
    public var name: String { return "OP_WITHIN" }

    // (x1 min max -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(3)

        let x = try context.number(at: -3)
        let minValue = try context.number(at: -2)
        let maxValue = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        context.stack.removeLast()
        context.pushToStack(minValue <= x && x < maxValue)
    }
}

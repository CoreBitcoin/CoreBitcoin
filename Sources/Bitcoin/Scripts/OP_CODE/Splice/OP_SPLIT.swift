import Foundation

// Split the operand at the given position.
public struct OpSplit: OpCodeProtocol {
    public var value: UInt8 { return 0x7f }
    public var name: String { return "OP_SPLIT" }

    // input : in position
    // output : x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let data: Data = context.data(at: -2)

        // Make sure the split point is apropriate.
        let position: Int32 = try context.number(at: -1)
        guard position <= data.count else {
            throw OpCodeExecutionError.error("Invalid OP_SPLIT range")
        }

        let n1: Data = data.subdata(in: 0..<Int(position))
        let n2: Data = data.subdata(in: Int(position)..<data.count)

        // Replace existing stack values by the new values.
        context.stack[context.stack.count - 2] = n1
        context.stack[context.stack.count - 1] = n2
    }
}

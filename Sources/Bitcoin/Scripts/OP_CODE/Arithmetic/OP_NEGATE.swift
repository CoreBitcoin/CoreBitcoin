import Foundation

// negates the number, pops it from stack and pushes result.
public struct OpNegate: OpCodeProtocol {
    public var value: UInt8 { return 0x8f }
    public var name: String { return "OP_NEGATE" }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(-input)
    }
}

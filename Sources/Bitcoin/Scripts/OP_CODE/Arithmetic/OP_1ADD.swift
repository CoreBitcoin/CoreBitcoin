import Foundation

// 1 is added to the input.
public struct Op1Add: OpCodeProtocol {
    public var value: UInt8 { return 0x8b }
    public var name: String { return "OP_1ADD" }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(input + 1)
    }
}

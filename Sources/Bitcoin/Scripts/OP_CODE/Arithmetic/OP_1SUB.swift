import Foundation

// 1 is subtracted from the input.
public struct Op1Sub: OpCodeProtocol {
    public var value: UInt8 { return 0x8c }
    public var name: String { return "OP_1SUB" }

    // (in -- out)
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(input - 1)
    }
}

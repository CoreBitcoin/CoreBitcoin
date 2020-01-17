import Foundation

// Removes the top two stack items.
public struct Op2Drop: OpCodeProtocol {
    public var value: UInt8 { return 0x6d }
    public var name: String { return "OP_2DROP" }

    // input : x1 x2
    // output : Nothing
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        context.stack.removeLast()
        context.stack.removeLast()
    }
}

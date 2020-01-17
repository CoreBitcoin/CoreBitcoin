import Foundation

// Removes the top stack item.
public struct OpDrop: OpCodeProtocol {
    public var value: UInt8 { return 0x75 }
    public var name: String { return "OP_DROP" }

    // input : x
    // output : Nothing
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)
        context.stack.removeLast()
    }
}

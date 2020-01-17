import Foundation

// Removes the second-to-top stack item.
public struct OpNip: OpCodeProtocol {
    public var value: UInt8 { return 0x77 }
    public var name: String { return "OP_NIP" }

    // input : x1 x2
    // output : x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let count: Int = context.stack.count
        context.stack.remove(at: count - 2)
    }
}

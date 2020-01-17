import Foundation

// The item at the top of the stack is copied and inserted before the second-to-top item.
public struct OpTuck: OpCodeProtocol {
    public var value: UInt8 { return 0x7d }
    public var name: String { return "OP_TUCK" }

    // input : x1 x2
    // output : x2 x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let x: Data = context.data(at: -1)
        let count: Int = context.stack.count
        context.stack.insert(x, at: count - 2)
    }
}

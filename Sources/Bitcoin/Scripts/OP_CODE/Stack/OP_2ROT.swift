import Foundation

// The fifth and sixth items back are moved to the top of the stack.
public struct Op2Rot: OpCodeProtocol {
    public var value: UInt8 { return 0x7b }
    public var name: String { return "OP_2ROT" }

    // input : x1 x2 x3 x4 x5 x6
    // output : x3 x4 x5 x6 x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(6)
        let x1: Data = context.data(at: -6)
        let x2: Data = context.data(at: -5)
        let count: Int = context.stack.count
        context.stack.removeSubrange(count - 6 ..< count - 4)
        context.stack.append(x1)
        context.stack.append(x2)
    }
}

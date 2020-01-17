import Foundation

// The item n back in the stack is moved to the top.
public struct OpRoll: OpCodeProtocol {
    public var value: UInt8 { return 0x7a }
    public var name: String { return "OP_ROLL" }

    // input : xn ... x2 x1 x0 <n>
    // output : ... x2 x1 x0 xn
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let n: Int32 = try context.number(at: -1)
        context.stack.removeLast()
        guard n >= 0 else {
            throw OpCodeExecutionError.error("\(name): n should be greater than or equal to 0.")
        }
        let index: Int = Int(n + 1)
        try context.assertStackHeightGreaterThanOrEqual(index)
        let count: Int = context.stack.count
        let xn: Data = context.stack.remove(at: count - index)
        context.stack.append(xn)
    }
}

import Foundation

// The item n back in the stack is copied to the top.
public struct OpPick: OpCodeProtocol {
    public var value: UInt8 { return 0x79 }
    public var name: String { return "OP_PICK" }

    // input : xn ... x2 x1 x0 <n>
    // output : xn ... x2 x1 x0 xn
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let n: Int32 = try context.number(at: -1)
        context.stack.removeLast()
        guard n >= 0 else {
            throw OpCodeExecutionError.error("\(name): n should be greater than or equal to 0.")
        }
        let index: Int = Int(n + 1)
        try context.assertStackHeightGreaterThanOrEqual(index)
        let xn: Data = context.data(at: -index)
        context.stack.append(xn)
    }
}

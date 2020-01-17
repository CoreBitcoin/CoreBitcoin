import Foundation

// Boolean AND between each bit of the inputs
public struct OpAnd: OpCodeProtocol {
    public var value: UInt8 { return 0x84 }
    public var name: String { return "OP_AND" }

    // input : x1 x2
    // output : out
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x2 = context.stack.removeLast()
        let x1 = context.stack.removeLast()

        // Inputs must be the same size
        guard x1.count == x2.count else {
            throw OpCodeExecutionError.error("Invalid operand size")
        }

        let count: Int = x1.count
        var output = Data(count: count)
        for i in 0..<count {
            output[i] = x1[i] & x2[i]
        }
        context.stack.append(output)
    }
}

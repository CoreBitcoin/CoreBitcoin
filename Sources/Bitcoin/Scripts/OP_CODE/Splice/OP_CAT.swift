import Foundation

// Concatenates two strings.
public struct OpConcatenate: OpCodeProtocol {
    public var value: UInt8 { return 0x7e }
    public var name: String { return "OP_CAT" }

    // input : x1 x2
    // output : out
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)
        let x1: Data = context.data(at: -2)
        let x2: Data = context.data(at: -1)
        guard x1.count + x2.count <= BTC_MAX_SCRIPT_ELEMENT_SIZE else {
            throw OpCodeExecutionError.error("Push value size limit exceeded")
        }
        context.stack.removeLast()
        context.stack.removeLast()
        context.stack.append(x1 + x2)
    }
}

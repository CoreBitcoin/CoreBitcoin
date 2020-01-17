import Foundation

// Copies the pair of items two spaces back in the stack to the front.
public struct Op2Over: OpCodeProtocol {
    public var value: UInt8 { return 0x70 }
    public var name: String { return "OP_2OVER" }

    // input : x1 x2 x3 x4
    // output : x1 x2 x3 x4 x1 x2
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(4)
        let x1: Data = context.data(at: -4)
        let x2: Data = context.data(at: -3)
        context.stack.append(x1)
        context.stack.append(x2)
    }
}

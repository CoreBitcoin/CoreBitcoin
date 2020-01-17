import Foundation

// (x y -- x-y)
public struct OpSub: OpCodeProtocol {
    public var value: UInt8 { return 0x94 }
    public var name: String { return "OP_SUB" }

    // (x1 x2 -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = try context.number(at: -2)
        let x2 = try context.number(at: -1)

        context.stack.removeLast()
        context.stack.removeLast()
        try context.pushToStack(x1 - x2)
    }
}

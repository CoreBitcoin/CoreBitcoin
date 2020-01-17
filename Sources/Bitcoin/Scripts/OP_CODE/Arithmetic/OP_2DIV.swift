import Foundation

// The input is divided by 2. disabled.
public struct Op2Div: OpCodeProtocol {
    public var value: UInt8 { return 0x8e }
    public var name: String { return "OP_2DIV" }

    public func isEnabled() -> Bool {
        return false
    }

    // (in -- out)
     public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)

        let input = try context.number(at: -1)
        context.stack.removeLast()
        try context.pushToStack(input / 2)
    }
}

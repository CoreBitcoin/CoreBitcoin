import Foundation

// Returns 1 if the inputs are exactly equal, 0 otherwise.
public struct OpEqual: OpCodeProtocol {
    public var value: UInt8 { return 0x87 }
    public var name: String { return "OP_EQUAL" }

    // input : x1 x2
    // output : true / false
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(2)

        let x1 = context.stack.popLast()!
        let x2 = context.stack.popLast()!
        let equal: Bool = x1 == x2
        context.pushToStack(equal)
    }
}

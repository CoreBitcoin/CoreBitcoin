import Foundation

// The number -1 is pushed onto the stack.
public struct Op1Negate: OpCodeProtocol {
    public var value: UInt8 { return 0x4f }
    public var name: String { return "OP_1NEGATE" }
    // input : -
    // output : -1
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.pushToStack(-1)
    }
}

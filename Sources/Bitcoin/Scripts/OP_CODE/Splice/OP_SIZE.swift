import Foundation

// Pushes the string length of the top element of the stack (without popping it).
public struct OpSize: OpCodeProtocol {
    public var value: UInt8 { return 0x82 }
    public var name: String { return "OP_SIZE" }

    // input : in
    // output : in size
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.assertStackHeightGreaterThanOrEqual(1)
        let x: Data = context.data(at: -1)
        try context.pushToStack(Int32(x.count))
    }
}

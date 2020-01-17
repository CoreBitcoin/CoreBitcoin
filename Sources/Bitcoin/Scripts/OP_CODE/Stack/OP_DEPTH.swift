import Foundation

// Puts the number of stack items onto the stack.
public struct OpDepth: OpCodeProtocol {
    public var value: UInt8 { return 0x74 }
    public var name: String { return "OP_DEPTH" }

    // input : Nothing
    // output : <Stack size>
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        let count: Int = context.stack.count
        try context.pushToStack(Int32(count))
    }
}

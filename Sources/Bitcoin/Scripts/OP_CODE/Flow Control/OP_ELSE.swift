import Foundation

public struct OpElse: OpCodeProtocol {
    public var value: UInt8 { return 0x67 }
    public var name: String { return "OP_ELSE" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        guard !context.conditionStack.isEmpty else {
            throw OpCodeExecutionError.error("Expected an OP_IF or OP_NOTIF branch before OP_ELSE.")
        }
        let f = context.conditionStack.removeLast()
        context.conditionStack.append(!f)
    }
}

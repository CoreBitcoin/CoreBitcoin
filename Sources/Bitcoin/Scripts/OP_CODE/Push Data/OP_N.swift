import Foundation

// The number in the word name (1-16) is pushed onto the stack.
public struct OpN: OpCodeProtocol {
    public var value: UInt8 { return 0x50 + n }
    public var name: String { return "OP_\(n)" }
    private let n: UInt8
    internal init(_ n: UInt8) {
        guard (1...16).contains(n) else {
            fatalError("OP_N can be initialized with N between 1 and 16. \(n) is not valid.")
        }
        self.n = n
    }

    // input : -
    // output : n
    public func mainProcess(_ context: ScriptExecutionContext) throws {
        try context.pushToStack(Int32(n))
    }
}

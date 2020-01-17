import Foundation

public struct OpNop1: OpCodeProtocol {
    public var value: UInt8 { return 0xb0 }
    public var name: String { return "OP_NOP1" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop4: OpCodeProtocol {
    public var value: UInt8 { return 0xb3 }
    public var name: String { return "OP_NOP4" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop5: OpCodeProtocol {
    public var value: UInt8 { return 0xb4 }
    public var name: String { return "OP_NOP5" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop6: OpCodeProtocol {
    public var value: UInt8 { return 0xb5 }
    public var name: String { return "OP_NOP6" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop7: OpCodeProtocol {
    public var value: UInt8 { return 0xb6 }
    public var name: String { return "OP_NOP8" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop8: OpCodeProtocol {
    public var value: UInt8 { return 0xb7 }
    public var name: String { return "OP_NOP8" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop9: OpCodeProtocol {
    public var value: UInt8 { return 0xb8 }
    public var name: String { return "OP_NOP9" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

public struct OpNop10: OpCodeProtocol {
    public var value: UInt8 { return 0xb9 }
    public var name: String { return "OP_NOP10" }

    public func mainProcess(_ context: ScriptExecutionContext) throws {
        // do nothing
    }
}

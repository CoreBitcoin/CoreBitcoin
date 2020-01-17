import Foundation

public struct HeadersMessage {
    // The main client will never send us more than this number of headers.
    public static let MAX_HEADERS: Int = 2000

    /// Number of block headers
    public var count: VarInt {
        return VarInt(headers.count)
    }
    /// Block headers
    public let headers: [BlockMessage]

    public func serialized() -> Data {
        var data = Data()
        data += count.serialized()
        for header in headers {
            data += header.serialized()
        }
        return data
    }

    public static func deserialize(_ data: Data) throws -> HeadersMessage {
        let byteStream = ByteStream(data)
        let count = byteStream.read(VarInt.self)
        let countValue = count.underlyingValue
        guard countValue <= MAX_HEADERS else {
            throw ProtocolError.error("Too many headers: got \(countValue) which is larger than \(MAX_HEADERS)")
        }
        var blockHeaders = [BlockMessage]()
        for _ in 0..<countValue {
            let blockHeader: BlockMessage = BlockMessage.deserialize(byteStream)
            guard blockHeader.transactions.isEmpty else {
                throw ProtocolError.error("Block header does not have transaction")
            }
            blockHeaders.append(blockHeader)
        }
        return HeadersMessage(headers: blockHeaders)
    }
}

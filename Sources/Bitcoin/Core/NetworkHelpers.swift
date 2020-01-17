import Foundation

func ipv4(from data: Data) -> String {
    return Data(data.dropFirst(12)).map { String($0) }.joined(separator: ".")
}

func ipv6(from data: Data) -> String {
    return stride(from: 0, to: data.count - 1, by: 2).map { Data([data[$0], data[$0 + 1]]).hex }.joined(separator: ":")
}

/// Convert Internet address format from text to binary
func pton(_ address: String) -> Data {
    var addr = in6_addr()
    _ = withUnsafeMutablePointer(to: &addr) {
        inet_pton(AF_INET6, address, UnsafeMutablePointer($0))
    }
    var buffer = Data(count: 16)
    _ = buffer.withUnsafeMutableBytes { memcpy($0.baseAddress.unsafelyUnwrapped, &addr, 16) }
    return buffer
}

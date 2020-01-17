import Foundation

extension Address {
    public enum HashType: UInt8 {
        case pubKeyHash = 0
        case scriptHash = 8
    }
}

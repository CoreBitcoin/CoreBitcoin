import Foundation

public enum AddressError: Error {
    case invalid
    case invalidVersionByte
    case invalidDataSize
    case bitsConversionFailed
}

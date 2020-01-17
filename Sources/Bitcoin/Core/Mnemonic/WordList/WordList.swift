import Foundation

public extension Mnemonic {
	enum WordList {}
}

internal extension Mnemonic.WordList {
	/// `2^11 => 2048`
	static let sizeLog2 = 11
}

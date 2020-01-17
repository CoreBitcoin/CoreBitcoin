import Foundation

// MARK: Strength
public extension Mnemonic {
	enum Strength: Int, CaseIterable {
		case `default` = 128
		case low = 160
		case medium = 192
		case high = 224
		case veryHigh = 256
	}
}

public extension Mnemonic.Strength {

	/// `wordCount` must be divisible by `3`, else `nil` is returned
	init?(wordCount: Int) {
		guard wordCount % Mnemonic.Strength.checksumBitsPerWord == 0 else { return nil }
		let entropyInBitsFromWordCount = (wordCount / Mnemonic.Strength.checksumBitsPerWord) * 32
		self.init(rawValue: entropyInBitsFromWordCount)
	}

	init?(byteCount: Int) {
		let bitCount = byteCount * bitsPerByte
		guard
			let strength = Mnemonic.Strength(rawValue: bitCount)
			else { return nil }
		self = strength
	}
}

// MARK: - Internal

internal extension Mnemonic.Strength {

	static let checksumBitsPerWord = 3

	var byteCount: Int {
		return rawValue / bitsPerByte
	}

	var wordCount: Int {
		return Mnemonic.Strength.wordCountFrom(entropyInBits: rawValue)
	}

	static func wordCountFrom(entropyInBits: Int) -> Int {
		return Int(ceil(Double(entropyInBits) / Double(Mnemonic.WordList.sizeLog2)))
	}

	var checksumLengthInBits: Int {
		return wordCount / Mnemonic.Strength.checksumBitsPerWord
	}
}

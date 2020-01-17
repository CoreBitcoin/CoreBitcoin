import Foundation

extension RangeReplaceableCollection where Self: MutableCollection {

	/// Equivalence to Python's operator on lists: `[:n]`, e.g. `x = [1, 2, 3, 4, 5]; x[:3] // equals: [1, 2, 3]`
	func prefix(maxCount: Int) -> Self {
		return Self(self.prefix(maxCount))
	}

	/// Equivalent to Python's `[-n]`, e.g.`"Hello"[-3] // equals: "llo"`
	func suffix(maxCount: Int) -> Self {
		return Self(self.suffix(maxCount))
	}

	/// Equivalence to Python's operator on string: `[:-n]`, e.g.`"Hello"[:-3] // equals: "He"`
	func prefix(subtractFromCount n: Int) -> Self {
		let specifiedCount = count - n
		guard specifiedCount > 0 else { return Self() }
		return prefix(maxCount: specifiedCount)
	}

	func splitIntoChunks(ofSize maxLength: Int) -> [Self] {
		precondition(maxLength > 0, "groups must be greater than zero")
		var start = startIndex
		return stride(from: 0, to: count, by: maxLength).map { _ in
			let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
			defer { start = end }
			return Self(self[start..<end])
		}
	}
}

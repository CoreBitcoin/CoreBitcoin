import Foundation

// Faster than ceil(log(x)/log(2.0))
func ceil_log2(_ x: UInt32) -> UInt32 {
    if x == 0 { return 0 }
    guard x > 1 else { return 0 }
    var xx: UInt32 = x - 1
    var r: UInt32 = 0
    while xx > 0 {
        xx >>= 1
        r += 1
    }
    return r
}

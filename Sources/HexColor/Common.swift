import Foundation

// MARK: - Public

/// `UInt32`
public typealias HexWord = UInt32

public extension HexWord {
  var hexString: String { .init(format: "%02X", self) }
}

// MARK: - Internal

func hex_assert(_ hex: HexWord, _ has_alpha: Bool) {
  assert(has_alpha || hex & 0xffffff == hex, """
      A `\(hex.hexString)` has been interpreted as a `\((hex & 0xffffff).hexString)` -- which is considered wrong.
      Hex value must have only 3 of `0xFF` groups if no `has_alpha` flag provided. Or use `.init(hex: String)` instead.
      """)
}

/// `UInt8`
typealias HexByte = UInt8

/// Create an RGBA tuple from UInt32 hex value. Supports optional alpha component at the end.
/// - Parameters:
///   - hex: be like a `0xaabbcc` or `0xaabbcc00`.
///   - has_alpha: if true, interpret last components of `0xaabbcc00` as alpha value. Otherwise -- the hex should be like a `0xaabbcc`.
///   - type: type constraint. CGFloat, Double, etc.
/// - Returns: a typed RGBA tuple of the provided type.
func create_rgba_t<T: FloatingPoint>(hex: HexWord, has_alpha: Bool, _ type: T.Type) -> (r: T, g: T, b: T, a: T) {
  (
    T(get_component(order: has_alpha + 2, from: hex)) / 255,
    T(get_component(order: has_alpha + 1, from: hex)) / 255,
    T(get_component(order: has_alpha + 0, from: hex)) / 255,
    has_alpha ? T(get_component(from: hex)) / 255 : 1 // alpha
  )
}

/// Scanning a string in order to find there a UInt32 value.
/// - Parameter str: Both `0xaabbcc(dd)` or `#aabbcc(dd)` supported.
/// - Returns: A tuple with a `hex` value found in the and a `has_alpha` flag indicating if the string contains 4 of 0xFF groups.
func scan_hex(_ str: String) -> (hex: HexWord, has_alpha: Bool)? {
  let hexstr = str.trimmingCharacters(in: CharacterSet.alphanumerics.inverted) // remove leading '#'
  let has_alpha = (hexstr.split(separator: "x").last?.count ?? 0) > 6 // count components after '0x'
  let scanner = Scanner(string: hexstr)
  var hex_result: HexWord = 0

  if scanner.scanHexInt32(&hex_result) { // parse with 0x or not
    return (hex_result, has_alpha)
  }
  return nil
}

// MARK: - Private

/// Description
/// - Parameters:
///   - order: order description
///   - hex: hex normalized to rgba a.k.a. 0xaabbccdd
/// - Returns: description
private func get_component(order: HexByte = 0, from hex: HexWord) -> HexWord {
  let shift = order * 8
  let mask: HexWord = 0xff << shift
  let hex_component = (hex & mask) >> shift

  return hex_component
}

/// Interpret Bool.true as 1 and .false as 0.
private func + (lhs: Bool, rhs: HexByte) -> HexByte {
  lhs ? (rhs + 1) : rhs
}

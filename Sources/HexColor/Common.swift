import Foundation

// MARK: - Public

/// `UInt32`
public typealias HexWord = UInt32

public extension HexWord {
  var hexString: String { .init(format: "%02X", self) }
}

// MARK: - Internal

/// `UInt8`
typealias HexByte = UInt8

func create_rgba_t<T: FloatingPoint>(hex: HexWord, has_alpha: Bool, _ type: T.Type) -> (T, T, T, T) {
  (
    T(get_component(order: has_alpha + 2, from: hex)) / 255,
    T(get_component(order: has_alpha + 1, from: hex)) / 255,
    T(get_component(order: has_alpha + 0, from: hex)) / 255,
    has_alpha ? T(get_component(from: hex)) / 255 : 1 // alpha
  )
}

/// <#Description#>
/// - Parameter str: <#str description#>
/// - Returns: <#description#>
func parse_hex(_ str: String) -> (hex: HexWord, has_alpha: Bool)? {
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

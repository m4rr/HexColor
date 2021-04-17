import Foundation

protocol HexProtocol {}

extension UInt32 {
  var hexString: String { .init(format: "%02X", arguments: [self]) }

}

/// Description
/// - Parameters:
///   - order: order description
///   - hex: hex normalized to rgba a.k.a. 0xaabbccdd
/// - Returns: description
private func get_component(order: UInt8, from hex: UInt32) -> UInt32 {
//  let rgb_normalized_to_rgbA = has_alpha(hex) ? hex : hex << 8 // append 00 if no alpha at the end
  let shift = order * 8
  let mask: UInt32 = 0xff << shift
  let hex_component = (hex & mask) >> shift

  return hex_component
}

private func create_rgb_t<T: FloatingPoint>(hex: UInt32, of: T.Type) -> (T, T, T, T) {
  (
    T(get_component(order: 2, from: hex)) / 255,
    T(get_component(order: 1, from: hex)) / 255,
    T(get_component(order: 0, from: hex)) / 255,
    1 // alpha
  )
}

private func create_rgba_t<T: FloatingPoint>(hex: UInt32, of: T.Type) -> (T, T, T, T) {
  (
    T(get_component(order: 3, from: hex)) / 255,
    T(get_component(order: 2, from: hex)) / 255,
    T(get_component(order: 1, from: hex)) / 255,
    T(get_component(order: 0, from: hex)) / 255 // alpha
  )
}

private func create_t<T: FloatingPoint>(hex: UInt32, of t: T.Type, has_alpha: Bool = false) -> (T, T, T, T) {
  has_alpha ? create_rgba_t(hex: hex, of: t) : create_rgb_t(hex: hex, of: t)
}

/// <#Description#>
/// - Parameter str: <#str description#>
/// - Returns: <#description#>
private func parse_hex(_ str: String) -> (UInt32, Bool)? {
  let hexstr = str.trimmingCharacters(in: CharacterSet.alphanumerics.inverted) // remove leading '#'
  let has_alpha = (hexstr.split(separator: "x").last?.count ?? 0) > 6 // count components after '0x'
  let scanner = Scanner(string: hexstr)
  var hex_result: UInt32 = 0

  if scanner.scanHexInt32(&hex_result) { // parse with 0x or not
    return (hex_result, has_alpha)
  }
  return nil
}

#if canImport(UIKit)
import UIKit

public extension UIColor {
  /// Creates UIColor from 0xabcdef.
  /// - Parameter hex: hex number
  convenience init(hex: UInt32) {
    assert(hex & 0xffffff == hex)

    self.init(hexRGB: hex)
  }

  private convenience init(hexRGB hex: UInt32) {
    let rgba = create_rgb_t(hex: hex, of: CGFloat.self)

    self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
  }

  convenience init(hexRGBA hex: UInt32) {
    let rgba = create_rgba_t(hex: hex, of: CGFloat.self)

    self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
  }

  /// Creates UIColor from "0xabcdef", "0xabcdefaa" or "#abcdef".
  /// - Returns: nil if no number found in the string (parsing failed)
  /// - Parameter str: hex number as string
  convenience init?(hex str: String) {
    guard let (hex, has_alpha_component) = parse_hex(str) else {
      return nil
    }

    if has_alpha_component {
      self.init(hexRGBA: hex)
    } else {
      self.init(hexRGB: hex)
    }
  }
}
#endif

#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public extension Color {
  init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex: UInt32) {
    let rgba = create_rgba_t(hex: hex, of: Double.self)

    self.init(colorSpace, red: rgba.0, green: rgba.1, blue: rgba.2, opacity: rgba.3)
  }

  init?(_ colorSpace: Color.RGBColorSpace = .sRGB, hex: String) {
    if let color = UIColor(hex: hex) {
      self.init(color)
    } else {
      return nil
    }
  }
}
#endif

#if canImport(AppKit)
import AppKit

extension NSColor {
  convenience init(hex: UInt64) {
    let rgba = create_rgba(hex: hex)

    self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
  }

  convenience init?(hex str: String) {
    if let hex = parse_hex(str) {
      self.init(hex: hex)
    } else {
      return nil
    }
  }
}
#endif

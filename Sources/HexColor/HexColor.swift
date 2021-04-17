import Foundation

private func has_alpha(_ i: UInt64) -> Bool {
  i & 0xff000000 != 0
}

private func get_component(order: UInt8 = 0, from hex: UInt64) -> CGFloat {
  let rgb_normalized_to_rgbA = has_alpha(hex) ? hex : hex << 8 // append 00 if no alpha at the end
  let shift = order * 8
  let mask: UInt64 = 0xff << shift
  let hex_component = (rgb_normalized_to_rgbA & mask) >> shift

  return CGFloat(hex_component) / 255
}

private func create_rgba(hex: UInt64) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
  (
      red: get_component(order: 3, from: hex),
    green: get_component(order: 2, from: hex),
     blue: get_component(order: 1, from: hex),
    alpha: (has_alpha(hex) ? get_component(from: hex) : 1)
  )
}

private func parse_hex(_ str: String) -> UInt64? {
  let hexstr = str.trimmingCharacters(in: CharacterSet.alphanumerics.inverted) // remove leading '#'
  let scanner = Scanner(string: hexstr)
  var hex_result: UInt64 = 0

  if scanner.scanHexInt64(&hex_result) { // parse with 0x or not
    return hex_result
  }
  return nil
}

public extension UInt64 {
  var hexString: String { .init(format:"%02X", self) }
}

#if canImport(AppKit)

import AppKit

extension NSColor {
  convenience init(hex: uint64) {
    let rgba = create_rgba(hex: hex)

    self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
  }

  convenience init?(hex str: String) {
    if let hex = parse_hex(str) {
      self.init(hex: hex)
    }
    return nil
  }
}

#endif

#if canImport(UIKit)
import UIKit

public extension UIColor {
  convenience init(hex: UInt64) {
    let rgba = create_rgba(hex: hex)

    self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
  }

  convenience init?(hex str: String) {
    if let hex = parse_hex(str) {
      self.init(hex: hex)
    }
    return nil
  }
}

#if canImport(SwiftUI)
import SwiftUI


//  public extension Color {
//    init(hex: UInt64) {
//      self.init(UIColor(hex: hex))
//    }
//
//    init?(hex: String) {
//      if let color = UIColor(hex: hex) {
//        self.init(color)
//      } else {
//        return nil
//      }
//    }
//  }

#endif
#endif


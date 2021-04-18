#if canImport(SwiftUI)
import SwiftUI
@available(iOS 13.0, macOS 10.15, *)
public extension Color {

  /// Creates a Color from a hex value.
  /// - Parameter hex: Hex value be like  a `0xAABBCC(DD)`.
  /// - Parameter has_alpha: If the hex parameter supposet to contain last `0x(DD)` group as an alpha component, then `has_alpha` flag has to be set to true.
  /// Default value is false.
  init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex: HexWord, has_alpha: Bool = false) {
    hex_assert(hex, has_alpha)

    let tuple = create_rgba_t(hex: hex, has_alpha: has_alpha, Double.self)
    self.init(colorSpace, red: tuple.r, green: tuple.g, blue: tuple.b, opacity: tuple.a)
  }

  /// Creates a UIColor from a  hex value string.
  /// - Parameter str: hex number as a string of `"0xAABBCC(DD)"` or `"#AABBCC(DD)"`.
  /// - Returns: `.black` if no number found in the string (parsing failed)
  init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex str: String) {
    if let (hex, has_alpha_component) = scan_hex(str) {
      self.init(colorSpace, hex: hex, has_alpha: has_alpha_component)
    } else {
      self.init(colorSpace, white: 0, opacity: 1)
    }
  }

}
#endif

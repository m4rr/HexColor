#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public extension Color {

  /// <#Description#>
  /// - Parameters:
  ///   - colorSpace: <#colorSpace description#>
  ///   - hex: <#hex description#>
  ///   - has_alpha: <#has_alpha description#>
  init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex: HexWord, has_alpha: Bool = false) {
    assert(has_alpha || hex & 0xffffff == hex, "\(hex) must have only `0xaabbcc` groups, no more")

    let rgba = create_rgba_t(hex: hex, has_alpha: has_alpha, Double.self)
    self.init(colorSpace,
              red: rgba.0,
              green: rgba.1,
              blue: rgba.2,
              opacity: rgba.3)
  }

  /// - Returns: black if no number found in the string (parsing failed)
  init(_ colorSpace: Color.RGBColorSpace = .sRGB, hex str: String) {
    if let (hex, has_alpha_component) = parse_hex(str) {
      self.init(colorSpace, hex: hex, has_alpha: has_alpha_component)
    } else {
      self.init(colorSpace, white: 0, opacity: 1)
    }
  }

}
#endif

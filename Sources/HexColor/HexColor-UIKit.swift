#if canImport(UIKit)
import UIKit

public extension UIColor {

  /// Creates a UIColor from a hex value.
  /// - Parameter hex: Hex value be like  a `0xAABBCC(DD)`.
  /// - Parameter has_alpha: If the hex parameter supposet to contain last `0x(DD)` group as an alpha component, then `has_alpha` flag has to be set to true.
  /// Default value is false.
  convenience init(hex: HexWord, has_alpha: Bool = false) {
    assert(has_alpha || hex & 0xffffff == hex, """
      Hex value must only have 3 of `0xff` groups if no has_alpha flag provided.
      Currently \(hex) is interpreted as \((hex & 0xffffff).hexString), which is wrong.
      """)

    let tuple = create_rgba_t(hex: hex, has_alpha: has_alpha, CGFloat.self)
    self.init(red: tuple.0, green: tuple.1, blue: tuple.2, alpha: tuple.3)
  }

  /// Creates a UIColor from a  hex value string.
  /// - Parameter str: hex number as a string of `"0xAABBCC(DD)"` or `"#AABBCC(DD)"`.
  /// - Returns: `.black` if no number found in the string (parsing failed)
  convenience init(hex str: String) {
    if let (hex, has_alpha_component) = scan_hex(str) {
      self.init(hex: hex, has_alpha: has_alpha_component)
    } else {
      self.init(white: 0, alpha: 1)
    }
  }
  
}
#endif

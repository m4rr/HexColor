#if canImport(UIKit)
import UIKit

public extension UIColor {

  /// Creates UIColor from `0xAABBCC`.
  /// - Parameter hex: hex number
  convenience init(hex: HexWord, has_alpha: Bool = false) {
    assert(has_alpha || hex & 0xffffff == hex, "\(hex) must have only `0xaabbcc` groups, no more")

    let rgba = create_rgba_t(hex: hex, has_alpha: has_alpha, CGFloat.self)
    self.init(red: rgba.0,
            green: rgba.1,
             blue: rgba.2,
            alpha: rgba.3)
  }

  /// Creates UIColor from `"0xAABBCC"`, `"0xAABBCC00"`, `"#AABBCC"` or `"#AABBCC00"`.
  /// - Returns: `.black` if no number found in the string (parsing failed)
  /// - Parameter str: hex number as string
  convenience init(hex str: String) {
    if let (hex, has_alpha_component) = parse_hex(str) {
      self.init(hex: hex, has_alpha: has_alpha_component)
    } else {
      self.init(white: 0, alpha: 1)
    }
  }
  
}
#endif

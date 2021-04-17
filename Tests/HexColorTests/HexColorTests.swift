import XCTest
@testable import HexColor

final class HexColorTests: XCTestCase {

  @available(iOS 1.0, *)
  func test_iOS() {
    #if canImport(UIKit)
    let appRed = UIColor(red: 0xFF/255, green: 0x3B/255, blue: 0x30/255, alpha: 1)
    let testC2 = UIColor(hex: 0xff3b30)
    let testC3 = UIColor(hex: "#ff3b30")

    XCTAssertEqual(testC2, appRed)
    XCTAssertNotNil(testC3)
    XCTAssertEqual(testC3, appRed)
    #endif
  }

  @available(macOS 1.0, *)
  func test_macOS() {
    #if canImport(AppKit)
    let appRed = NSColor(red: 0xFF/255, green: 0x3B/255, blue: 0x30/255, alpha: 1)
    let testC2 = NSColor(hex: 0xff3b30)
    let testC3 = NSColor(hex: "#ff3b30")

    XCTAssertEqual(testC2, appRed)
    XCTAssertNotNil(testC3)
    XCTAssertEqual(testC3, appRed)
    #endif
  }

}

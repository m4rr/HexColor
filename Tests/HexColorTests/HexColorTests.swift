import XCTest
@testable import HexColor

final class HexColorTests: XCTestCase {

  func test_iOS2() {
    #if canImport(UIKit)
    let appRed = UIColor(red: 0xFF/255, green: 0x3B/255, blue: 0x30/255, alpha: 1)

    let strs = ["#ff3b30"]

    strs
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), appRed)
      }

    #endif
  }


  @available(iOS 1.0, *)
  func test_iOS() {
    #if canImport(UIKit)
    let appRed = UIColor(red: 0xFF/255, green: 0x3B/255, blue: 0x30/255, alpha: 1)
    let ints: [UInt64] = [0xff3b30]
    let ints_failed: [UInt32] = [0xff3b30ff]
    let strs = ["0xff3b30ff", "0xff3b30", "#ff3b30", "#ff3b30ff"]


    ints
      .forEach { hex in
        XCTAssertEqual(UIColor(hex: hex), appRed)
      }

//    ints_failed
//      .forEach { hex in
//        XCTfaEqual(UIColor(hex: hex), appRed)
//      }

    strs
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), appRed)
      }

    #endif
  }

  func test_iOS_edge_cases() {
    #if canImport(UIKit)

    let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let black_ints: [UInt64] = [0x000000, 0x000000ff]
    let black_strs = ["0x000000", "0x000000ff", "#000000", "#000000ff"]

    black_ints
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), black)
      }

    black_strs
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), black)
      }


    let white = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let white_ints: [UInt64] = [0xffffff, 0xffffffff]
    let white_strs = ["0xffffff", "0xffffffff", "#ffffff", "#ffffffff"]

    white_ints
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), white)
      }

    white_strs
      .forEach {
        XCTAssertEqual(UIColor(hex: $0), white)
      }

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

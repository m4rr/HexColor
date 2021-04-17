import XCTest
@testable import HexColor

final class HexColorTests: XCTestCase {

  func testExample() {
    let appRed = UIColor(red: 0xFF/255, green: 0x3B/255, blue: 0x30/255, alpha: 1)
    let testC2 = UIColor(hex: 0xff3b30)
    let testC3 = UIColor(hex: "#ff3b30")

    XCTAssertEqual(testC2, appRed)
    XCTAssertEqual(testC3, appRed)
  }

}

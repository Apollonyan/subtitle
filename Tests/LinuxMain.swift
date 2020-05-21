import XCTest

import subtitleTests

var tests = [XCTestCaseEntry]()
tests += subtitleTests.allTests()
XCTMain(tests)

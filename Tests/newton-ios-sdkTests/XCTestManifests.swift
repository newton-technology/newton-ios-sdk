import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(newton_ios_sdkTests.allTests),
    ]
}
#endif

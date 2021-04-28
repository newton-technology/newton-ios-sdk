import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NewtonAuthTests.allTests),
        testCase(AuthResultTests.allTests),
        testCase(AuthErrorTests.allTests),
    ]
}
#endif

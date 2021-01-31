import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AngleTests.allTests),
        testCase(ClampTests.allTests),
        testCase(Matrix4x4Tests.allTests),
        testCase(RectTests.allTests),
        testCase(Vector2fTests.allTests),
    ]
}
#endif

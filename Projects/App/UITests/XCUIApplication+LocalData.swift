import XCTest

extension XCUIApplication {
    /// UI tests run against the local sample catalog so CI does not depend on live server data.
    func launchWithLocalData() {
        launchArguments.append("-ui-test-local-data")
        launch()
    }
}

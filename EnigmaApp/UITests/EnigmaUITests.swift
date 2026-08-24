import XCTest

/// Test UI di base dell'app Enigma.
///
/// Gli identificatori di accessibilità (`plaintextField`, `ciphertext`,
/// `lamp-<lettera>`) rendono i test indipendenti dalla lingua del simulatore.
final class EnigmaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsTitle() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Enigma"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testTypingProducesCiphertext() throws {
        let app = XCUIApplication()
        app.launch()

        let field = app.textFields["plaintextField"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("HELLO")

        let ciphertext = app.staticTexts["ciphertext"]
        XCTAssertTrue(ciphertext.waitForExistence(timeout: 5))
        // Enigma è simmetrica: "HELLO" produce 5 lettere di cifrato.
        XCTAssertEqual(ciphertext.label.count, 5)
        // Il cifrato non deve coincidere con il testo in chiaro.
        XCTAssertNotEqual(ciphertext.label, "HELLO")
    }

    @MainActor
    func testLampboardKeyAppendsToPlaintext() throws {
        let app = XCUIApplication()
        app.launch()

        let lampA = app.buttons["lamp-A"]
        XCTAssertTrue(lampA.waitForExistence(timeout: 5))
        lampA.tap()

        let field = app.textFields["plaintextField"]
        XCTAssertEqual(field.value as? String, "A")
    }
}

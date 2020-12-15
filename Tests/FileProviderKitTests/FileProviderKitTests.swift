import XCTest
@testable import FileProviderKit

final class FileProviderKitTests: XCTestCase {
    func testDocumentManagetShouldWriteInDocumentDirectory() {
		guard let documentDirectory = DocumentManager.shared.cacheDirectory else {
			XCTFail("Documents directory not found")
			return
		}

		XCTAssertTrue(FileManager.default.fileExists(atPath: documentDirectory.path))
		let dstFile = documentDirectory.appendingPathComponent("test.txt")

		do {
			try "Hello world\n".data(using: .utf8)!.write(to: dstFile)
		} catch let error {
			XCTFail(error.localizedDescription)
		}

		XCTAssertTrue(FileManager.default.fileExists(atPath: dstFile.path))
		try? FileManager.default.removeItem(at: dstFile)
    }

    static var allTests = [
        ("testDocumentManagetShouldWriteInDocumentDirectory", testDocumentManagetShouldWriteInDocumentDirectory),
    ]
}

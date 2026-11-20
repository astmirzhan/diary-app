import XCTest
@testable import DiaryCore

final class DiaryCoreTests: XCTestCase {
    func testEntryRoundTripPreservesMarkdown() throws {
        let entry = DiaryEntry(
            id: UUID(uuidString: "13d4c019-54ad-4a6f-a6d5-c18f4b53e1dc")!,
            createdAt: Date(timeIntervalSince1970: 1_700_000_000),
            body: "Сегодня работал над Ayeka.",
            fileName: "entry.md"
        )

        let parsed = DiaryEntry.parse(fileName: "entry.md", contents: entry.markdown)

        XCTAssertEqual(parsed?.id, entry.id)
        XCTAssertEqual(parsed?.body, entry.body)
        XCTAssertEqual(parsed?.fileName, "entry.md")
    }

    func testStoreLoadsAndDeletesEntry() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let store = EntryStore(directory: temporaryDirectory)
        let entry = DiaryEntry(body: "Локальная запись")

        try store.save(entry)
        XCTAssertEqual(try store.load().first?.body, "Локальная запись")

        try store.delete(entry)
        XCTAssertTrue(try store.load().isEmpty)
    }
}

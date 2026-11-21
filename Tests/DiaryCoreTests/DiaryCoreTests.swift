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

    func testGraphExtractorAddsPersonAndProjectAndUnresolvedMention() {
        var graph = DiaryGraph()
        GraphExtractor.addProject("Ayeka", graph: &graph)
        let firstEntry = DiaryEntry(body: "Бекарыс помог с Ayeka.")
        GraphExtractor.update(graph: &graph, entry: firstEntry)

        XCTAssertTrue(graph.entities.contains { $0.name == "Бекарыс" && $0.kind == .person })
        XCTAssertTrue(graph.entities.contains { $0.name == "Ayeka" && $0.kind == .project })
        XCTAssertTrue(graph.relations.contains { $0.entryID == firstEntry.id })
    }

    func testGraphStoreRoundTrip() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let store = GraphStore(directory: temporaryDirectory)
        let graph = DiaryGraph(
            entities: [DiaryEntity(name: "Бекарыс", kind: .person)]
        )

        try store.save(graph)
        XCTAssertEqual(try store.load(), graph)
    }
}

import Foundation

public final class GraphStore: @unchecked Sendable {
    public let fileURL: URL

    public init(directory: URL? = nil) {
        let entryDirectory = EntryStore(directory: directory).directory
        fileURL = entryDirectory
            .deletingLastPathComponent()
            .appendingPathComponent("graph.json")
    }

    public func load() throws -> DiaryGraph {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return DiaryGraph()
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(DiaryGraph.self, from: data)
    }

    public func save(_ graph: DiaryGraph) throws {
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let data = try JSONEncoder().encode(graph)
        try data.write(to: fileURL, options: .atomic)
    }
}

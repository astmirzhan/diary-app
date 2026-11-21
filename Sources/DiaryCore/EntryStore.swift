import Foundation

public final class EntryStore: @unchecked Sendable {
    public let directory: URL

    public init(directory: URL? = nil) {
        if let directory {
            self.directory = directory
        } else {
            if let iCloudDirectory = FileManager.default.url(
                forUbiquityContainerIdentifier: nil
            )?.appendingPathComponent("Documents", isDirectory: true)
                .appendingPathComponent("DiaryApp", isDirectory: true)
                .appendingPathComponent("entries", isDirectory: true) {
                self.directory = iCloudDirectory
            } else {
                let applicationSupport = FileManager.default.urls(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask
                )[0]
                self.directory = applicationSupport
                    .appendingPathComponent("DiaryApp", isDirectory: true)
                    .appendingPathComponent("entries", isDirectory: true)
            }
        }

        try? FileManager.default.createDirectory(
            at: self.directory,
            withIntermediateDirectories: true
        )
    }

    public func load() throws -> [DiaryEntry] {
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        ).filter { $0.pathExtension == "md" }

        return try fileURLs.compactMap { url in
            let contents = try String(contentsOf: url, encoding: .utf8)
            return DiaryEntry.parse(fileName: url.lastPathComponent, contents: contents)
        }.sorted { $0.createdAt > $1.createdAt }
    }

    public func save(_ entry: DiaryEntry) throws {
        let fileURL = directory.appendingPathComponent(entry.fileName)
        try entry.markdown.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    public func delete(_ entry: DiaryEntry) throws {
        let fileURL = directory.appendingPathComponent(entry.fileName)
        try FileManager.default.removeItem(at: fileURL)
    }
}

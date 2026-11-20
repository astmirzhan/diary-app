import Foundation

public struct DiaryEntry: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var createdAt: Date
    public var body: String
    public var fileName: String

    public init(id: UUID = UUID(), createdAt: Date = Date(), body: String = "", fileName: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.body = body
        self.fileName = fileName ?? "\(Self.fileDateFormatter.string(from: createdAt))-\(id.uuidString).md"
    }

    public var markdown: String {
        let date = Self.markdownDateFormatter.string(from: createdAt)
        return "---\nid: \(id.uuidString)\ncreated: \(date)\n---\n\n\(body)\n"
    }

    public static func parse(fileName: String, contents: String) -> DiaryEntry? {
        guard contents.hasPrefix("---\n") else {
            return nil
        }

        let parts = contents.components(separatedBy: "---")
        guard parts.count >= 3 else {
            return nil
        }

        let frontMatter = parts[1]
        let body = parts.dropFirst(2).joined(separator: "---").trimmingCharacters(in: .newlines)

        guard let idLine = frontMatter
            .components(separatedBy: .newlines)
            .first(where: { $0.hasPrefix("id: ") }),
            let id = UUID(uuidString: String(idLine.dropFirst(4)))
        else {
            return nil
        }

        let created = frontMatter
            .components(separatedBy: .newlines)
            .first(where: { $0.hasPrefix("created: ") })
            .flatMap { markdownDateFormatter.date(from: String($0.dropFirst(9))) } ?? Date()

        return DiaryEntry(id: id, createdAt: created, body: body, fileName: fileName)
    }

    private static let markdownDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let fileDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        return formatter
    }()
}

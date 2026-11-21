import Foundation

public enum EntityKind: String, Codable, Sendable {
    case person
    case project
    case topic
    case emotion
}

public struct DiaryEntity: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var kind: EntityKind
    public var aliases: [String]

    public init(
        id: UUID = UUID(),
        name: String,
        kind: EntityKind,
        aliases: [String] = []
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.aliases = aliases
    }
}

public struct DiaryRelation: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let sourceEntityID: UUID
    public let targetEntityID: UUID
    public let entryID: UUID
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        sourceEntityID: UUID,
        targetEntityID: UUID,
        entryID: UUID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sourceEntityID = sourceEntityID
        self.targetEntityID = targetEntityID
        self.entryID = entryID
        self.createdAt = createdAt
    }
}

public struct UnresolvedMention: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let entryID: UUID
    public var name: String
    public var candidateEntityIDs: [UUID]

    public init(
        id: UUID = UUID(),
        entryID: UUID,
        name: String,
        candidateEntityIDs: [UUID] = []
    ) {
        self.id = id
        self.entryID = entryID
        self.name = name
        self.candidateEntityIDs = candidateEntityIDs
    }
}

public struct DiaryGraph: Codable, Equatable, Sendable {
    public var entities: [DiaryEntity]
    public var relations: [DiaryRelation]
    public var unresolvedMentions: [UnresolvedMention]

    public init(
        entities: [DiaryEntity] = [],
        relations: [DiaryRelation] = [],
        unresolvedMentions: [UnresolvedMention] = []
    ) {
        self.entities = entities
        self.relations = relations
        self.unresolvedMentions = unresolvedMentions
    }
}

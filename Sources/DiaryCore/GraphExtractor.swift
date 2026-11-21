import Foundation

public enum GraphExtractor {
    public static func update(
        graph: inout DiaryGraph,
        entry: DiaryEntry
    ) {
        let words = entry.body
            .components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .filter { $0.count >= 2 }

        let existingNames = graph.entities.map(\.name)
        let capitalizedWords = words.filter { word in
            guard let first = word.first else {
                return false
            }
            return first.isUppercase && !existingNames.contains(word)
        }

        let personNames = Set(capitalizedWords.filter {
            $0.unicodeScalars.allSatisfy { $0.properties.isAlphabetic }
        })

        var createdEntities: [DiaryEntity] = []
        for name in personNames {
            let matches = graph.entities.filter { entity in
                entity.kind == .person &&
                    (entity.name.caseInsensitiveCompare(name) == .orderedSame ||
                     entity.aliases.contains { $0.caseInsensitiveCompare(name) == .orderedSame })
            }

            if matches.count == 1 {
                continue
            }

            if matches.isEmpty {
                if !createdEntities.contains(where: {
                    $0.name.caseInsensitiveCompare(name) == .orderedSame
                }) {
                    createdEntities.append(DiaryEntity(name: name, kind: .person))
                }
            } else {
                if !graph.unresolvedMentions.contains(where: {
                    $0.entryID == entry.id &&
                        $0.name.caseInsensitiveCompare(name) == .orderedSame
                }) {
                    graph.unresolvedMentions.append(
                        UnresolvedMention(
                            entryID: entry.id,
                            name: name,
                            candidateEntityIDs: matches.map(\.id)
                        )
                    )
                }
            }
        }

        graph.entities.append(contentsOf: createdEntities)

        let names = graph.entities.filter { $0.kind == .person }
        for person in names {
            if entry.body.range(
                of: person.name,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil {
                for project in graph.entities.filter({ $0.kind == .project }) {
                    if entry.body.range(
                        of: project.name,
                        options: [.caseInsensitive, .diacriticInsensitive]
                    ) != nil {
                        if !graph.relations.contains(where: {
                            $0.sourceEntityID == person.id &&
                                $0.targetEntityID == project.id &&
                                $0.entryID == entry.id
                        }) {
                            graph.relations.append(
                                DiaryRelation(
                                    sourceEntityID: person.id,
                                    targetEntityID: project.id,
                                    entryID: entry.id,
                                    createdAt: entry.createdAt
                                )
                            )
                        }
                    }
                }
            }
        }
    }

    public static func addProject(
        _ name: String,
        graph: inout DiaryGraph
    ) {
        guard !graph.entities.contains(where: {
            $0.kind == .project &&
                $0.name.caseInsensitiveCompare(name) == .orderedSame
        }) else {
            return
        }
        graph.entities.append(DiaryEntity(name: name, kind: .project))
    }
}

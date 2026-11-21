import Foundation
import SwiftUI
import DiaryCore

@MainActor
final class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var selectedEntryID: UUID?
    @Published var draft = ""
    @Published var errorMessage: String?

    private let store = EntryStore()
    private let graphStore: GraphStore
    private var graph: DiaryGraph

    init() {
        graphStore = GraphStore(directory: store.directory)
        graph = (try? graphStore.load()) ?? DiaryGraph()
        refresh()
    }

    var selectedEntry: DiaryEntry? {
        guard let selectedEntryID else {
            return nil
        }
        return entries.first { $0.id == selectedEntryID }
    }

    func refresh() {
        do {
            entries = try store.load()
            if let selectedEntryID,
               entries.contains(where: { $0.id == selectedEntryID }) {
                draft = selectedEntry?.body ?? ""
            } else {
                selectedEntryID = entries.first?.id
                draft = entries.first?.body ?? ""
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func select(_ entry: DiaryEntry) {
        selectedEntryID = entry.id
        draft = entry.body
    }

    func newEntry() {
        if selectedEntry != nil {
            saveSelected()
        }

        let entry = DiaryEntry(body: "")
        do {
            try store.save(entry)
            entries.insert(entry, at: 0)
            selectedEntryID = entry.id
            draft = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveSelected() {
        guard var entry = selectedEntry else {
            return
        }
        entry.body = draft
        do {
            try store.save(entry)
            GraphExtractor.update(graph: &graph, entry: entry)
            try graphStore.save(graph)
            if let index = entries.firstIndex(where: { $0.id == entry.id }) {
                entries[index] = entry
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteSelected() {
        guard let entry = selectedEntry else {
            return
        }
        do {
            try store.delete(entry)
            entries.removeAll { $0.id == entry.id }
            selectedEntryID = entries.first?.id
            draft = entries.first?.body ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

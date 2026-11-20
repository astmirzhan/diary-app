import SwiftUI
import DiaryCore

struct ContentView: View {
    @EnvironmentObject private var model: DiaryViewModel

    var body: some View {
        NavigationSplitView {
            timeline
                .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 320)
        } detail: {
            editor
        }
        .alert("Не удалось сохранить запись", isPresented: Binding(
            get: { model.errorMessage != nil },
            set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(model.errorMessage ?? "")
        }
    }

    private var timeline: some View {
        List(selection: Binding(
            get: { model.selectedEntryID },
            set: { id in
                if let entry = model.entries.first(where: { $0.id == id }) {
                    model.select(entry)
                }
            }
        )) {
            ForEach(model.entries) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.createdAt, format: .dateTime.day().month().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(entry.body.trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .first(where: { !$0.isEmpty }) ?? "Новая запись")
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
                .tag(entry.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: model.newEntry) {
                    Label("Новая запись", systemImage: "square.and.pencil")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: model.deleteSelected) {
                    Label("Удалить", systemImage: "trash")
                }
                .disabled(model.selectedEntry == nil)
            }
        }
    }

    private var editor: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let entry = model.selectedEntry {
                Text(entry.createdAt, format: .dateTime.weekday(.wide).day().month().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 28)
                    .padding(.top, 18)
            }

            TextEditor(text: $model.draft)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .onChange(of: model.draft) {
                    model.saveSelected()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

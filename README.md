<div align="center">

<img src="docs/banner.svg" alt="diary: a private AI diary for projects and life, stored as plain Markdown" width="100%" />

# diary: write freely, let the app find the connections

**A local-first diary for projects and life. Your entries stay plain Markdown on your device; the app links the people, projects and feelings in them.**

<p align="center">
  <img src="https://img.shields.io/badge/Status-Early_prototype-E4A11B?style=for-the-badge" alt="Early prototype" />
  <img src="https://img.shields.io/badge/License-MIT-1F1B16?style=for-the-badge" alt="MIT license" />
  <a href="https://github.com/astmirzhan/diary-app/actions/workflows/test.yml"><img src="https://img.shields.io/github/actions/workflow/status/astmirzhan/diary-app/test.yml?branch=main&style=for-the-badge&label=Tests" alt="Tests" /></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 5.9" />
  <img src="https://img.shields.io/badge/SwiftUI-macOS_14_·_iOS_17-0A84FF?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/Storage-Markdown_·_iCloud-7A6E60?style=for-the-badge&logo=markdown&logoColor=white" alt="Markdown and iCloud" />
  <img src="https://img.shields.io/badge/Obsidian-readable-7C3AED?style=for-the-badge&logo=obsidian&logoColor=white" alt="Readable in Obsidian" />
</p>

</div>

---

## 📓 The idea

Most journaling apps make you choose: write freely, or keep things organised with tags, links and folders.
This one keeps the writing free. You type about your day, your projects, the people around you, how you feel,
and the app works out who and what you mean, building a graph of your life in the background.

| | |
| --- | --- |
| **Plain files** | Every entry is a `.md` file with a small front matter block. Open the folder in Obsidian or any editor |
| **Private by default** | Entries live on your device (or your own iCloud). AI runs locally, or only with explicit consent |
| **No manual linking** | No `[[links]]` or tags to maintain; people and projects are recognised from the text |
| **Asks, not guesses** | Two friends with the same name? The app records the mention as unresolved and asks which one you meant |

## 🚦 Status

This is an early prototype. What works today and what is next:

| | Feature |
| --- | --- |
| ✅ | macOS SwiftUI app: timeline sidebar and a distraction-free serif editor |
| ✅ | Entries saved as Markdown with `id` and `created` front matter, autosaved while typing |
| ✅ | Storage in iCloud Documents when available, otherwise Application Support |
| ✅ | Graph model: people, projects, topics, emotions, relations between them, unresolved mentions |
| ✅ | First rule-based extractor: finds names, links people to projects mentioned in the same entry |
| 🔜 | On-device language model for entities, dates ("yesterday", "last week") and mood |
| 🔜 | One-tap prompt to resolve ambiguous names, remembered as aliases |
| 🔜 | Graph view and daily stats (mood, weight, time) |
| 🔜 | iOS app from the same code; Russian and Kazakh support |

## 🧩 How it works

```mermaid
%%{init: {"theme": "base", "themeVariables": {"primaryColor": "#F6F2EA", "primaryTextColor": "#1F1B16", "primaryBorderColor": "#7A6E60", "lineColor": "#7A6E60", "secondaryColor": "#FFFFFF", "tertiaryColor": "#EFE8DA", "fontFamily": "monospace"}}}%%
flowchart LR
  subgraph App["🖥️ DiaryApp · SwiftUI"]
    UI["Timeline + editor"]
    VM["DiaryViewModel<br/>autosave"]
  end
  subgraph Core["📦 DiaryCore"]
    ES["EntryStore<br/>.md files"]
    GE["GraphExtractor"]
    GS["GraphStore<br/>graph JSON"]
  end
  Disk[("📁 iCloud Documents<br/>or Application Support")]
  UI --> VM
  VM -- "save entry" --> ES
  VM -- "update graph" --> GE --> GS
  ES --> Disk
  GS --> Disk
```

An entry on disk looks like this:

```markdown
---
id: 6F1C2B7E-0D4A-4C1F-9B57-3E2D8C1FA92E
created: 2026-11-21T09:30:00Z
---

Went for a run with Alex this morning.
Tired, but the new feature finally works.
```

- **`DiaryCore`** is a plain Swift library (entries, Markdown parsing, storage, graph), so it can be shared by macOS and iOS apps and tested without UI.
- **`DiaryApp`** is a thin SwiftUI layer on top: `NavigationSplitView` with the timeline and the editor.
- **Graph entities** have a kind (`person`, `project`, `topic`, `emotion`) and aliases; a mention that matches several people becomes an `UnresolvedMention` instead of a wrong link.

## 🛠️ Run it

Requires macOS 14+ and Swift 5.9+.

```bash
swift run DiaryApp   # open the app
swift test           # DiaryCore tests
```

```
Sources/
  DiaryApp/     SwiftUI app: DiaryApp, ContentView, DiaryViewModel
  DiaryCore/    DiaryEntry, EntryStore, GraphModels, GraphExtractor, GraphStore
Tests/
  DiaryCoreTests/
```

## 🤝 Contributing

Ideas and issues are welcome. The project is small and moving fast, so open an issue before a large pull request.

<div align="center">

**diary** · MIT · your life, in plain text 📓

</div>

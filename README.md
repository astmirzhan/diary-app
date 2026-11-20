# diary-app

An open-source, local-first AI diary for projects and life.

The app is intentionally being built around a simple principle: your writing remains
ordinary Markdown on your own device. AI features will be local or require explicit
consent before any cloud processing.

## Status

Early macOS prototype. This repository currently includes the SwiftUI shell and a
file-based Markdown entry store.

## Development

Requirements:

- macOS 14 or later
- Swift 5.9 or later

```bash
swift run DiaryApp
swift test
```

## Storage

Entries are stored as Markdown files in:

`~/Library/Application Support/DiaryApp/entries`

The format is designed to remain readable in Obsidian.

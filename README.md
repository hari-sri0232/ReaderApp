# ReaderApp

ReaderApp is an iOS application that fetches news articles from a remote API, stores them locally using Core Data, and allows users to bookmark articles for offline reading. The app uses Swift concurrency (async/await), modern architecture with MVVM, and supports UIKit.

---

## Features

- Fetch news articles asynchronously using `URLSession` and `async/await`
- Save articles locally with Core Data for offline access
- Bookmark articles and manage bookmarks separately
- Separate tabs for all articles and bookmarked articles
- Uses `@MainActor` and Swift concurrency best practices
- Unit testing with mock services and dependency injection

---

## Architecture

- **NetworkManager:** Responsible for API calls and decoding JSON
- **ArticlesViewModel:** Handles business logic, data fetching, and exposes data to the UI
- **Core Data:** Persistent storage for articles and bookmarks
- **UIKit:** User interface with UITableView and UITabBarController

---

## Setup

1. Clone the repo:

```bash
git clone https://github.com/yourusername/ReaderApp.git
cd ReaderApp

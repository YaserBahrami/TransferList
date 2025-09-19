# TransferList iOS App

This iOS application is built using Swift and the Combine framework, showcasing a clean architecture with MVVM and Coordinator pattern, network handling, and UI implementation using SnapKit. It interacts with The Movie Database (TMDb) API to fetch popular movies and allow users to search for movies by name.

## Features


## Technologies Used

- **Swift**: The primary programming language.
- **Combine**: For handling asynchronous data streams and reactive programming.
- **SnapKit**: For easy layout management.

## Architecture

This project follows the **MVVM** (Model-View-ViewModel) architecture along with **Clean Architecture** principles and Coordinator pattern, making the codebase modular, maintainable, and easy to scale.

### Layers:
1. **Model**: Represents the data (Movie, API responses, etc.).
2. **View**: The UI components such as `MovieListViewController` and `MovieDetailsViewController`.
3. **ViewModel**: The intermediary between the view and use cases, responsible for fetching data and providing it to the view.
4. **UseCases**: The business logic layer that interacts with the repository to fetch data.
5. **Repository**: Responsible for fetching data from the network layer and providing it to the use cases.


## Setup

### Requirements

- Xcode 16.0 or later
- Swift 5.0 or later
- macOS 15.6 or later

### Installation

1. Clone the repository:
```bash
  git clone https://github.com/YaserBahrami/TransferList.git
```
2. Navigate to the project directory:
```bash
  cd TransferList
```
3. Install dependencies using Cocoapods:
```bash
  pod install
```
4. Open the project in Xcode:
```bash
  open TransferList.xcodeproj
```

### Dependencies

- **Combine**: For managing reactive streams.
- **SnapKit**: For AutoLayout in code.

## Usage


## App Flow

- **Home Screen**: Displays a list of Transfer Lists
- **Search**: Allows users to search for movies by title.


## Improvements (If More Time Was Available)

If I had more time, the following improvements and features could be added:


## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) license




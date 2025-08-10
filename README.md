# StackOverflow Users App

An iOS app that demonstrates some of my key skills. Although I typically work in an MVVM structure I've seen this as a good oppurtunity to study and adopt MVVM+C. I currently work with IGListKit so wanted to stick to a similar design principle of using collection views with sections and switching these sections based on the current state of the view. I've used mainly storyboards but also with some programatic alterations, mostly around cell display handling. I've also used a small full programatic display for the following indicator.

## Features

- Fetches and displays StackOverflow users with their profiles
- Shows user reputation and profile images
- Implements a following system with local persistence
- Supports light and dark mode
- Provides loading and error states
- Utilises modern UICollectionView with diffable data sources
- Implements proper memory management and weak references

## Architecture

The application follows the MVVM (Model-View-ViewModel) architecture pattern with a coordinator for navigation:

- **Models**: Data structures representing StackOverflow users
- **Views**: UICollectionView-based interface with custom cells
- **ViewModels**: Business logic and data transformation
- **Coordinators**: Navigation and flow control

### Key Components

- `ProfileCoordinator`: Manages navigation and view creation
- `ProfileListViewController`: Main view controller displaying user list
- `UserViewModel`: View model handling business logic relating to data display.
- `DataLoader`: Network service for fetching user data
- `UserFollowingService`: Local persistence for following status

## Requirements

- iOS 15.6+
- Xcode 14.0+
- Swift 5.0+

## Project Structure

```
StackOverflowUsers/
├── AppDelegates/
├── Assets/
├── Coordinators/
├── Data Models/
├── Handlers/
├── Storyboards/
├── Supporting Files/
├── View Controllers/
├── View Model/
└── Views/
```

## Getting Started

1. Clone the repository
2. Open `StackOverflowUsers.xcodeproj` in Xcode
3. Build and run the project

## Testing

The project includes both unit tests and UI tests:

- `StackOverflowUsersTests`: Unit tests for business logic
- `StackOverflowUsersUITests`: UI tests for interface validation

Run tests using Cmd+U in Xcode or through the test navigator.

## Design Patterns

- **Coordinator Pattern**: For navigation and flow control
- **MVVM**: For separation of concerns and testability
- **Protocol-Oriented Programming**: For flexible and reusable components
- **Dependency Injection**: For better testability and modularity

## Network Layer

The app uses URLSession for networking with the StackExchange API:
- Fetches user data from the StackOverflow API
- Downloads and caches user profile images
- Handles various network states and errors

## Persistence

User following status is persisted locally using UserDefaults, making it available between app launches. UserDefaults was used over using core data simply for time management.

## UI Components

- Custom `FollowingIndicatorView` for following status
- Responsive collection view with dynamic sizing
- Loading and error states with appropriate visual feedback
- Smooth animations for state transitions

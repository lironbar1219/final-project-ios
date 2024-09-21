# Card War Game

This is a Swift-based iOS application, developed in Xcode, for a "Card War" game.

## Features

- **Firebase Authentication**: Secure login and user registration using Firebase.
- **Firebase Live Data**: Real-time data updates using Firebase, ensuring that the game state is synchronized across devices.
- **Timer Tasks**: In-game timers are used to manage turn durations and countdowns.
- **Audio Integration**: Custom sounds are triggered during different game events (stored in the `sounds` folder).
- **Card Assets**: Custom card images stored in the `CardsImages` directory.
- **Responsive UI**: Adaptive layouts for different screen sizes and orientations.

## Setup Instructions

### Prerequisites

- **Xcode**: Ensure you have Xcode installed (version compatible with Swift 5 or later).
- **Cocoapods**: Used for managing dependencies (such as Firebase).

### Installation

1. Clone or download this repository to your local machine.
2. Open the project in Xcode by double-clicking on the `.xcodeproj` file.
3. Install required dependencies by running the following command in the project root:
    ```bash
    pod install
    ```
4. Set up your Firebase project:
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new Firebase project and enable Authentication and Realtime Database.
   - Download the `GoogleService-Info.plist` file and replace the existing one in the root of the project.

5. Build and run the project on an emulator or physical device.

### Firebase Configuration

Make sure you have the following Firebase services enabled in your project:
- **Authentication**: Used for secure user login and registration.
- **Realtime Database**: Used for live data updates during the game.

### Project Structure

- **AppDelegate.swift & SceneDelegate.swift**: Handles application life cycle.
- **ViewController.swift**: Main game logic and UI management.
- **ViewControllers/**: Contains additional view controllers for various parts of the app.
- **Assets.xcassets/**: Contains the game's visual assets, including card images.
- **Firebase/**: Firebase setup and configurations.
- **AudioPlayer/**: Audio logic and handling sound playback during the game.
- **Constants/**: Stores constant values used throughout the app.

### Game Flow

1. **User Authentication**: Upon launching the app, users are prompted to sign in or register via Firebase Authentication.
2. **Card War Gameplay**: Players are dealt cards, and turns are timed using the timer feature. The live game state is updated using Firebase's real-time data feature.
3. **Sound Effects**: Custom sound effects are triggered during gameplay events.

### Known Issues

- Timer may lag on older devices.
- Firebase sync delays under poor network conditions.

### Demonstation

- You can watch the demonstration in this link:
https://drive.google.com/file/d/1eK7LCRQFP-vQ0lR6DBsma2l3V00L1mHc/view?usp=sharing

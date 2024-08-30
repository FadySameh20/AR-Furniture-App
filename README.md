# ARtful Home - AR Furniture Mobile Application

ARtful Home is a mobile application that uses Augmented Reality (AR) to help users visualize how furniture will look in their space. Below is a comprehensive guide on features, setup instructions, and dependencies.

## Features

### Basic Features
- **User-Friendly Interface**: Intuitive design for easy navigation and use.
- **User Authentication**: Secure login and account management using Firebase Authentication.
- **Real-Time Data Storage/Application**: Store and retrieve data in real-time with Firebase Firestore.
- **Single Furniture AR Testing**: Test one piece of furniture at a time using AR.
- **Gesture Manipulation**: Move (drag) and rotate (swipe) furniture pieces within the AR view.
- **Color Variants**: Select from different color options for furniture.
- **Furniture Search**: Search functionality to find specific furniture items.

### Advanced Features
- **Multiple Furniture AR Testing**: Test more than one piece of furniture simultaneously.
- **Light Estimation/Shadow Adjustment**: Enhanced realism with light and shadow effects.
- **Search Filter**: Refine search results with customizable filters.
- **Dark Mode**: Switch to a dark theme for comfortable viewing in low-light conditions.
- **Notifications**: Receive important updates and alerts.
- **Caching**: Improve performance and offline access with cached data.

## Setup Instructions

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=2.18.0 <3.0.0)

### Getting Started

1. **Clone the Repository**
   ```sh
   git clone https://github.com/FadySameh20/AR-Furniture-App.git
   cd AR-Furniture-App
   ```

2. **Install Dependencies**
   ```sh
   flutter pub get
   ```

3. **Run the Application**
   - For Android or iOS (make sure you have Xcode installed):
     ```sh
     flutter run
     ```

### Configuration

1. **Firebase Setup**
   - Follow [Firebase setup instructions](https://firebase.google.com/docs/flutter/setup) to integrate Firebase services with your project.
   - Configure Firebase Authentication, Firestore, Storage, and Messaging.

2. **AR Plugin Configuration**
   - Ensure AR capabilities are set up as described in the [ar_flutter_plugin documentation](https://pub.dev/packages/ar_flutter_plugin).

### Environment
```yaml
sdk: '>=2.18.0 <3.0.0'
```

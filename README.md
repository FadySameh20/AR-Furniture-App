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

### Feature Descriptions

- **Introduction and Onboarding:** Provides a brief introductory guide when the app is first installed, helping users get started with the application.

- **Account Management:**
  - **Login:** Securely log in using email and password.
  - **Register:** Create a new account by providing necessary details such as name, email, and address.
  - **Profile Editing:** Update personal information including name, password, and contact details.

- **Product Discovery:**
  - **Browse Categories:** Explore different furniture categories to find products of interest.
  - **Search and Filter:** Use search functionality and filters to find specific furniture items based on criteria like category, price range, and color.

- **Product Details:**
  - **View Furniture Details:** Access detailed information about products including images, descriptions, prices, and available colors.
  - **Augmented Reality (AR) Visualization:** Visualize how furniture items will look in your space using AR technology. Scan your environment, place furniture items, and adjust their positioning.

- **Favorites Management:**
  - **Add to Favorites:** Save preferred items to a favorites list for easy access later.
  - **View Favorites:** Access and manage your list of favorite items.

- **Shopping Cart:**
  - **Add to Cart:** Add desired furniture items to your shopping cart.
  - **Modify Cart:** Change quantities or remove items from the cart.
  - **View Cart Summary:** Review all items in the cart and see the total order value.

- **Checkout Process:**
  - **Enter Personal Information:** Provide necessary details for order fulfillment, including name, phone number, and address.
  - **Order Confirmation:** Review order details and complete the purchase.

- **Order Tracking:**
  - **Track Orders:** Monitor the status of your orders from purchase to delivery.
   
- **Notifications:**
  - **Receive Updates:** Get notified about new offers, discounts, and order status changes.

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

### Customer Demo
https://github.com/user-attachments/assets/130c124e-6efc-4b81-a111-14aeeb96dc86

### AR Demo
https://github.com/user-attachments/assets/633d8bfb-c17e-4094-9564-67674ae4a4be

Note: You can decrease the video speed from video's settings

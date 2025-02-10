# iOS Signup and Sign-In Module

This project demonstrates a Signup and Sign-In module for an iOS application. The app implements user authentication via a mock API, validates user inputs, and supports offline storage for authenticated user sessions. The project follows a clean architecture approach, adhering to best practices in iOS development.

---

## Features Checklist

### Signup Screen
- [x] Full Name input field
- [x] Email input field with format validation
- [x] Password input field with the following requirements:
  - [x] Minimum 6 characters
  - [x] At least one uppercase letter
  - [x] At least one number
  - [x] At least one special character
- [x] Confirm Password field (must match Password)
- [x] Date of Birth field (Date Picker with a minimum age of 18)
- [x] Gender selection
- [x] "Sign Up" button enabled only after all fields are valid
- [x] POST request to a mock API for user registration
- [x] Handle success and error responses

### Sign-In Screen
- [x] Email input field with format validation
- [x] Password input field (non-empty)
- [x] "Sign In" button enabled only after inputs are valid
- [x] POST request to a mock API for user authentication
- [x] Store authentication token securely on success
- [x] Navigate to a Dashboard Screen with the user’s full name displayed
- [x] Save credentials locally using Keychain
- [x] Auto-login on app restart if a valid session exists, navigating to the Welcome Screen

---

## Technical Implementation
- [x] **Architecture:** Follows MVVM 
- [x] **Networking:** Uses URLSession for API calls
- [x] **Offline Storage:**
  - [x] Keychain for secure storage
  - [x] UserDefaults for local data
- [x] **UI:** Built with SwiftUI, ensuring responsiveness across devices

---

## Bonus Features
- [x] **Biometric Login:** Supports Face ID for returning users
- [ ] **Unit Tests:** Includes unit tests for:
  - [ ] Validation logic
  - [ ] Networking layer

---

## Overview
The app provides a seamless user authentication experience with robust validation, secure API integration, and offline session management. It is designed to be modular, scalable, and testable, following modern iOS development practices.

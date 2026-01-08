# Community Shared Spaces — Real-Time Availability App

A mobile app that gives residents of large housing communities real-time visibility into shared spaces (gyms, pools, halls, meeting rooms, parking, etc.). Users can securely sign in, view live availability, and check in/out with instantaneous updates across devices.

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Architecture Overview](#architecture-overview)
5. [Data Model](#data-model)
6. [Core Flows](#core-flows)
7. [Security & Rules](#security--rules)
8. [Project Structure](#project-structure)
9. [Setup & Installation](#setup--installation)
10. [Development Workflow](#development-workflow)
11. [Testing](#testing)
12. [Limitations (MVP)](#limitations-mvp)
13. [Future Enhancements](#future-enhancements)
14. [Contributing](#contributing)
15. [License](#license)

---

## Overview

In many residential communities, shared facilities are underutilized or overcrowded due to lack of visibility. This app acts as a single source of truth for shared spaces using Firebase’s real-time capabilities.

**MVP focus:** Simplicity, real-time accuracy, and minimal cognitive load for users.

---

## Features

### MVP Features
- Resident authentication (email & password)
- Unified dashboard listing all shared spaces
- Real-time occupancy updates (Firestore listeners)
- Check-in / Check-out functionality
- Space detail views
- Firestore-backed data storage

### Nice-to-Have (not in MVP)
- Space reservations
- Auto-release timers
- Push notifications
- Usage history and analytics
- Admin dashboard
- Payment integration

---

## Tech Stack

- **Frontend:** Flutter (Android-first MVP)
- **Backend / Services:** Firebase Authentication, Cloud Firestore
- **Build & Deployment:** Firebase CLI, APK builds (manual or CI)

---

## Architecture Overview

- Client-driven real-time architecture: the Flutter app connects directly to Firestore and listens for snapshot updates.
- Authentication via Firebase Auth.
- Business logic and access control enforced by Firestore Security Rules — no trusted client assumptions.

---

## Data Model

Collections and example documents:

- **/users/{userId}**
```json
{
	"name": "Aditya",
	"apartmentNumber": "A-302",
	"role": "resident",
	"createdAt": "timestamp"
}
```

- **/spaces/{spaceId}** — base model (type-specific fields allowed)
```json
{
	"id": "gym",
	"name": "Gym",
	"type": "gym",
	"status": "available", // "available" | "occupied" | "closed"
	"occupiedBy": null,     // userId or null
	"occupiedSince": null,  // timestamp or null
	"openTime": "05:00",
	"closeTime": "22:00",
	"lastUpdatedAt": "timestamp"
}
```

Type-specific fields (e.g., `capacity`, `pricing`, `equipment`, `slots`) may be added while preserving this base schema.

---

## Core Flows

### Check-In

- Preconditions: `status == "available"`.
- Firestore updates (atomic write):
	- `status` → `"occupied"`
	- `occupiedBy` → `currentUserId`
	- `occupiedSince` → `now`
	- `lastUpdatedAt` → `now`
- Result: update propagates instantly to all connected clients.

### Check-Out

- Allowed only when `occupiedBy == currentUserId`.
- Firestore updates:
	- `status` → `"available"`
	- `occupiedBy` → `null`
	- `occupiedSince` → `null`
	- `lastUpdatedAt` → `now`

---
---

## Project Structure (Flutter)

```
lib/
├── auth/
│   ├── login_screen.dart
│   └── signup_screen.dart
├── dashboard/
│   ├── dashboard_screen.dart
│   └── space_card.dart
├── spaces/
│   ├── space_detail_screen.dart
│   └── space_models.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
└── main.dart
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK
- Firebase account
- Android Studio or VS Code

### Steps
1. Clone the repository.
2. Create a Firebase project and enable:
	 - Email/Password Authentication
	 - Cloud Firestore
3. Add Firebase config files:
	 - Download `google-services.json` and place it in `android/app/`.
4. Run the app:

```bash
flutter pub get
flutter run
```

---

## Development Workflow

- Feature work happens on short-lived branches.
- Firestore schema changes must be reviewed before merging.
- UI changes should preserve the base space model to avoid breaking clients.
- Sprint-I prioritizes correctness over feature depth.

---

## Testing

- Manual testing across multiple devices/accounts to validate real-time sync.
- Test scenarios: concurrent check-in conflicts, network interruption, invalid state transitions.
- Automated testing is minimal for MVP.

---


## Future Enhancements

- Booking and reservation system
- Auto-release timers (auto check-out)
- Admin console
- Analytics and usage insights
- Push notifications (FCM)
- Payment integration
- Web client

---

## Contributing

Contributions are welcome after Sprint-I stabilization.

Please:
- Follow existing data models.
- Avoid breaking schema compatibility.
- Document any Firestore security rule changes.

---

## License

This project is currently unlicensed and intended for internal or experimental use. Add a license before public distribution.

---
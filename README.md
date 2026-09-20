# Smart Drop Box

Flutter mobile app for monitoring and controlling a smart parcel drop box: lock status, remote unlock (Bluetooth / Wi‑Fi), live weight and clearance sensors, and a delivery activity log.

## Run

```bash
flutter pub get
flutter run
```

## Features

- **Lock status** — Red when secured, green when unlocked, with glow indicator.
- **Tap to Unlock / Lock Container** — Primary action for remote lock control (mock service simulates hardware latency).
- **Live sensors** — Payload weight (kg) and interior clearance (cm) with space remaining.
- **Delivery log** — Recent events with timestamps; **View All** opens the full scrollable list.

## Hardware integration

Replace `MockDropBoxService` in `lib/main.dart` with an implementation of `DropBoxService` that talks to your solenoid controller over BLE or TCP/WebSocket.

# Invitor - Virtual Event Planning App

Invitor is a virtual event planning app that streamlines the process of organizing and participating in virtual events. Whether you're hosting a conference, workshop, or social gathering, Invitor provides a user-friendly platform for seamless event management and engagement.

## Features

- **User Authentication:** Allow users to create accounts, log in, and manage their profiles securely.
- **Event Creation:** Easily create and manage virtual events with customizable details.
- **Ticketing System:** Sell tickets or manage registrations for events with a built-in ticketing system.
- **Networking Tools:** Facilitate networking and communication among attendees and organizers.
- **Analytics and Reporting:** Gain insights into event performance and attendee engagement.

## Technologies Used

- [Flutter](https://flutter.dev/): UI toolkit for building natively compiled applications for mobile, web, and desktop.
- [Supabase](https://supabase.io/): Open-source Firebase alternative with a real-time database.

## Getting Started

1. **Clone the repository:** `git clone https://github.com/AlastiSolutions/invitor.git`
2. **Install dependencies:** `flutter pub get`
3. **Run the app:** `flutter run`

## Database Setup

1. Create an account on [Supabase](https://supabase.io/).
2. Set up a new project and obtain your API key.
3. Update the `supabase` configuration in the app.

```dart
// Replace these values with your Supabase project details
final supabase = SupabaseClient('https://yourprojecturl.supabase.co', 'your-api-key');
```

## Contributing

We welcome contributions! If you have suggestions or find issues, please open an issue or submit a pull request.
License

## License

This project is licensed under the MIT License.

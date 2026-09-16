# ☕ KŌVÉRA Coffee App

A modern, high-performance coffee ordering mobile application built with **Flutter**. Designed with a warm artisan coffee aesthetic, sleek typography, dynamic animations, and an intuitive shopping experience.

---

## ✨ Features

- **🏠 Interactive Home Screen**:
  - Pinned glassmorphic header with greeting and profile badge.
  - Quick-category selector (*Espresso, Cold Brew, Latte, Tea, Pastries*).
  - Search bar with instant real-time filtering, product grid transition, and automatic focus dismissal on submit.
  - Featured & popular coffee carousel with smooth hero animations.

- **🔍 Explore Screen**:
  - Comprehensive catalog of artisan drinks and bakery items.
  - Quick search and filter options.

- **❤️ Favorites & Wishlist**:
  - Heart toggle on product cards to save favorite blends.
  - Dedicated Favorites tab with instant addition/removal.

- **🛍️ Cart & Live Ordering**:
  - Persistent state management with instant quantity adjustment.
  - Dynamic subtotal, delivery fee calculation, and tip selectors (None, 10%, 15%, 20%).

- **💳 Smart & Secure Checkout**:
  - **Pickup vs. Delivery Toggle**: Dynamic adjustment between store pickup note and custom street delivery address.
  - **Editable Address**: Complete inputs for street address, apartment/suite, city, and postal code.
  - **Payment Options**: Support for Apple Pay, Cash on Delivery (COD), and Credit/Debit Cards.
  - **Card Formatting & Security**:
    - Automatic card spacing (`XXXX XXXX XXXX XXXX`) with a strict 16-digit limit.
    - Expiry date formatting (`MM/YY`) with month range validation (`01`–`12`).
    - CVV/CVC code limited strictly to 3 digits, obscured by default (`•••`) with a visibility toggle button.
    - Cardholder name validation.

- **⚡ Performance & Optimization**:
  - Optimized network image sizes with intelligent memory caching (`cacheWidth: 500`).
  - Strict `const` constructor usage for maximum 60fps rendering.

---

## 📱 Screenshots & Demo

| Home & Search | Product Detail | Cart & Checkout |
|:---:|:---:|:---:|
| *(Add your screenshot here)* | *(Add your screenshot here)* | *(Add your screenshot here)* |

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/) (SDK: `^3.12.2`)
- **Language**: [Dart](https://dart.dev/)
- **Styling & Fonts**: [Google Fonts](https://pub.dev/packages/google_fonts) (*Playfair Display* & *Plus Jakarta Sans*)
- **Icons**: Cupertino Icons & Material Design Icons
- **Architecture**: Modular folder architecture with centralized service patterns (`CartService`, `FavoriteService`).

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── data/
│   │   └── app_data.dart          # Mock products, categories & coffee data
│   ├── services/
│   │   ├── cart_service.dart      # Cart state management (singleton)
│   │   └── favorite_service.dart  # Favorites state management (singleton)
│   └── themes/
│       └── colors.dart            # Custom coffee-themed color palette
├── models/
│   ├── cart_item.dart             # Cart item data model
│   └── favorite_item.dart         # Favorite item data model
├── Screens/
│   ├── Checkout/
│   │   └── checkout_screen.dart   # Interactive checkout & payment screen
│   ├── Explore/
│   │   └── explore_screen.dart    # Explore & browse drinks
│   ├── Favorite/
│   │   └── favorite_screen.dart   # Saved items & favorites screen
│   ├── Home/
│   │   └── home_screen.dart       # Main dashboard & live search
│   ├── ProductDetail/
│   │   └── product_detail_screen.dart # Drink details, size selection & customizer
│   └── Profile/
│       └── profile_screen.dart    # User profile & preferences
├── widget/
│   ├── bottom_nav_bar.dart        # Custom floating navigation bar
│   ├── build_category_card.dart   # Category pill widget
│   ├── cart_item_card.dart        # Item card inside cart
│   └── product_card.dart          # Reusable coffee card widget
└── main.dart                      # App entry point
```

---

## 🚀 Getting Started & Setup Guide

Follow these steps to run the application locally on your machine.

### 1. Prerequisites

Make sure you have the following installed:
- [Git](https://git-scm.com/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.12 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter/Dart extensions.
- An Android Emulator, iOS Simulator, or a physical device connected with USB debugging enabled.

Verify your Flutter environment:
```bash
flutter doctor
```

---

### 2. Clone the Repository

```bash
git clone https://github.com/CodeWith-Basit/coffee_app.git
cd coffee_app
```

---

### 3. Install Dependencies

Fetch all the required packages:
```bash
flutter pub get
```

---

### 4. Run Code Analysis (Optional)

Verify there are no lint or syntax issues:
```bash
flutter analyze
```

---

### 5. Launch the Application

Make sure an emulator or device is running, then execute:

```bash
flutter run
```

> **Tip:** If multiple devices are connected, list them with `flutter devices` and run with:
> ```bash
> flutter run -d <device-id>
> ```

---

## 📦 Building the Application

### Build Android APK
```bash
flutter build apk --release
```
The output APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

### Build App Bundle (For Google Play Store)
```bash
flutter build appbundle --release
```

### Build for iOS
```bash
flutter build ios --release
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 👨‍💻 Author

**Abdul Basit**  
- GitHub: [@CodeWith-Basit](https://github.com/CodeWith-Basit)

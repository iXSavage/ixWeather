# 🌦️ ixWeather

A beautifully designed, responsive, and robust weather application built with Flutter.

ixWeather provides real-time weather updates, dynamic 7-day forecasting, and location-based automated weather tracking. Built with modern Flutter architecture patterns, it utilizes `Provider` for state management, `geolocator` for device hardware integration, and a highly polished UI featuring smooth Lottie micro-animations and custom gradients.

*Insert a GIF or Screenshot of the app running here*
<!-- Add an image using: <img src="assets/screenshots/demo.gif" width="300"> -->

---

## ✨ Features

- **📍 Auto-Location via GPS**: Automatically fetches current weather and regional forecast upon launch by tapping into native device location sensors.
- **🔍 Manual City Search**: Robust search functionality allowing users to look up the 7-day weather forecast anywhere in the world.
- **🎨 Dynamic UI & Micro-Animations**: Weather conditions are brought to life using beautiful `Lottie` animations that reflect the current climate.
- **📱 Responsive Layout Foundation**: Built using `flutter_screenutil` to ensure widgets scale gracefully across different device screen sizes.
- **🔒 Secure API Handling**: API Keys are strictly excluded from source control utilizing `.env` environment variables.

## 🛠️ Tech Stack & Architecture

This application focuses on clean architecture, separating UI components from business logic for testability and maintainability.

*   **Framework**: Flutter & Dart
*   **State Management**: `provider` (Separating `WeatherProvider` and `ForecastWeatherProvider`)
*   **Networking**: `http` (Consuming the [WeatherAPI](https://www.weatherapi.com/) REST endpoints)
*   **Hardware/Location**: `geolocator` (GPS coordinate tracking)
*   **Security**: `flutter_dotenv` (Local API credential management)
*   **Styling**: Custom Themeing, `flutter_screenutil`, `flutter_svg`, `lottie`

---

## 🚀 Getting Started

To run this project locally, ensure you have the Flutter SDK installed and an active emulator or physical device connected.

### Prerequisites

1.  **Flutter SDK**: `^3.7.2` or later.
2.  **WeatherAPI Key**: Create a free account at [WeatherAPI.com](https://www.weatherapi.com/) to get an API key.

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/ixWeather.git
    cd ixWeather
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configure Environment Variables**
    Create a `.env` file in the root directory and add your API Key:
    ```env
    WEATHER_API_KEY=your_weather_api_key_here
    ```

4.  **Run the App**
    ```bash
    flutter run
    ```

## 📂 Project Structure

```text
lib/
 ┣ models/             # Data classes (WeatherModel, ForecastWeatherModel)
 ┣ provider/           # Business logic and State Management (WeatherProvider, LocationHelper)
 ┣ screens/            # Main UI Pages (HomePage, SearchScreen)
 ┣ services/           # Network requests (WeatherService)
 ┣ widgets/            # Reusable UI components (WeatherCard, ForecastRow)
 ┣ constants.dart      # Global styling constants (Colors, Gradients, TextStyles)
 ┗ main.dart           # App entry point, Provider initialization
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/ixWeather/issues).

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

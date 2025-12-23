# Camaroo 📸

A professional cross-platform camera application for iOS and Android with DSLR-like functionality, advanced photo editing, and AI-assisted features.

## Features

### 🎥 Professional Camera Controls
- **Manual Shutter Speed Control**: Adjust shutter speed from 1/8000s to 1/30s
- **Exposure Time Control**: Fine-tune exposure for perfect lighting
- **ISO Adjustment**: Control sensitivity from 100 to 3200
- **Focal Length Control**: Adjust from 10mm to 200mm
- **Portrait Mode**: Professional depth-of-field effects
- **White Balance**: Customize color temperature (2000K-10000K)
- **Focus Modes**: Auto, manual, and continuous focus
- **Grid Overlay**: Rule of thirds composition guide
- **Histogram Display**: Real-time exposure analysis
- **Flash Control**: Auto, on, off, and torch modes

### 🎨 Advanced Photo Editor
- **Basic Adjustments**: Brightness, contrast, and saturation
- **Filters**: Grayscale, sepia, vintage, blur, and sharpen
- **Transform Tools**: Rotate, flip, and crop
- **Drawing Tools**: Add artistic touches to your photos
- **Text Overlay**: Add captions and annotations
- **AI Auto-Enhance**: Intelligent one-tap photo enhancement

### 📚 Gallery & Album Management
- **Smart Gallery**: Organized photo grid view
- **Custom Albums**: Create and manage photo collections
- **Favorites**: Mark and access your best shots
- **Search**: Find photos by tags
- **Batch Operations**: Select and organize multiple photos
- **Location Tagging**: Automatic GPS coordinates

### 🤖 AI-Assisted Features
- **Auto-Enhance**: Intelligent photo optimization
- **Scene Detection**: Automatic scene recognition
- **Face Detection**: Enhanced portrait mode
- **Smart Tagging**: Automatic photo categorization

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / Xcode
- Android SDK (API 21+) or iOS 12.0+

### Setup

1. Clone the repository:
```bash
git clone https://github.com/harisrovca/camaroo.git
cd camaroo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## Project Structure

```
camaroo/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   │   ├── photo.dart
│   │   ├── album.dart
│   │   └── camera_settings.dart
│   ├── screens/               # UI screens
│   │   ├── home_screen.dart
│   │   ├── camera_screen.dart
│   │   ├── gallery_screen.dart
│   │   ├── editor_screen.dart
│   │   ├── album_detail_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/               # Reusable widgets
│   │   ├── camera_controls.dart
│   │   ├── camera_overlay.dart
│   │   ├── photo_grid.dart
│   │   ├── album_list.dart
│   │   ├── editor_toolbar.dart
│   │   ├── adjustment_panel.dart
│   │   └── filter_panel.dart
│   └── services/              # Business logic
│       ├── camera_service.dart
│       ├── gallery_service.dart
│       └── editor_service.dart
├── android/                   # Android configuration
├── ios/                       # iOS configuration
├── assets/                    # Images, icons, filters
└── test/                      # Unit tests
```

## Dependencies

### Core Dependencies
- **camera**: Camera functionality
- **image**: Image processing
- **photo_manager**: Gallery access
- **provider**: State management
- **google_ml_kit**: Machine learning features
- **tflite_flutter**: TensorFlow Lite integration

### UI Components
- **flutter_colorpicker**: Color selection
- **image_cropper**: Crop functionality
- **photo_view**: Image viewing
- **carousel_slider**: Image carousel
- **flutter_staggered_grid_view**: Grid layouts

### Storage & Utilities
- **path_provider**: File system access
- **permission_handler**: Permission management
- **sqflite**: Local database
- **shared_preferences**: Settings storage

## Permissions

### Android
- Camera
- Storage (Read/Write)
- Location (Fine/Coarse)

### iOS
- Camera Usage
- Photo Library Usage
- Location When In Use

## Usage

### Taking Photos
1. Open the app and navigate to the Camera tab
2. Adjust professional settings using the top controls
3. Toggle grid overlay or histogram as needed
4. Tap the white circle button to capture
5. Photo is automatically saved and opened in editor

### Editing Photos
1. After capturing, the editor opens automatically
2. Tap "Adjust" for brightness, contrast, saturation
3. Tap "Filter" to apply artistic effects
4. Use "Crop", "Draw", or "Text" tools as needed
5. Tap "Save" to save your edited photo

### Managing Albums
1. Navigate to the Gallery tab
2. Switch to "Albums" view
3. Tap "+" to create a new album
4. Add photos to albums from photo details
5. View album contents by tapping on any album

## Architecture

Camaroo follows a clean architecture pattern with clear separation of concerns:

- **Models**: Data structures and entities
- **Services**: Business logic and state management (using Provider)
- **Screens**: UI pages and navigation
- **Widgets**: Reusable UI components

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open-source and available under the MIT License.

## Acknowledgments

- Flutter and the Flutter community
- Camera plugin contributors
- Image processing library contributors
- ML Kit and TensorFlow teams

## Support

For issues, questions, or contributions, please visit:
- GitHub Issues: https://github.com/harisrovca/camaroo/issues
- Discussions: https://github.com/harisrovca/camaroo/discussions

---

Made with ❤️ by the Camaroo team

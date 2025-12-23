# Quick Start Guide

Welcome to Camaroo! This guide will help you get started quickly.

## Prerequisites

Before you begin, make sure you have:

- **Flutter SDK** 3.0 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Android Studio** or **Xcode** (depending on your target platform)
- A physical device or emulator (camera features require a physical device for full functionality)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/harisrovca/camaroo.git
cd camaroo
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Check Your Setup

```bash
flutter doctor
```

Make sure all checks pass. If you see any issues, follow Flutter's instructions to fix them.

### 4. Connect a Device

#### For Android:
- Enable Developer Mode on your Android device
- Enable USB Debugging
- Connect via USB

Check if your device is connected:
```bash
flutter devices
```

#### For iOS:
- Connect your iPhone/iPad via USB
- Trust the computer on your device
- Open Xcode and select your device

### 5. Run the App

#### For Android:
```bash
flutter run -d android
```

#### For iOS:
```bash
flutter run -d ios
```

Or simply:
```bash
flutter run
```

Flutter will automatically select an available device.

## First Time Setup

When you first launch the app, you'll be asked to grant permissions:

1. **Camera Permission**: Required to take photos
2. **Storage Permission**: Required to save and view photos
3. **Location Permission**: Optional, for geotagging photos

## Quick Tour

### 1. Camera Screen
- **Main View**: Your default starting point
- **Top Controls**: Grid overlay, histogram, portrait mode toggle
- **Bottom Controls**: Gallery, capture button, camera switch
- **Settings**: Access via Settings tab for manual controls

### 2. Gallery Screen
- **Photos Tab**: View all your photos in a grid
- **Albums Tab**: Organize photos into albums
- **Favorites Tab**: Quick access to your favorite shots
- **Search**: Find photos by tags

### 3. Editor Screen
- Automatically opens after capturing a photo
- **Adjust**: Brightness, contrast, saturation
- **Filter**: Apply artistic effects
- **Crop/Rotate**: Transform your images
- **Save**: Export edited photos

### 4. Settings Screen
- **Manual Controls**: Adjust shutter speed, ISO, exposure, etc.
- **Focus Mode**: Auto, manual, or continuous
- **Flash Mode**: Auto, on, off, or torch
- **Display Options**: Grid overlay, histogram

## Tips for Best Results

### Professional Photography Tips

1. **Use Manual Controls**: For best results, experiment with manual settings
   - Lower ISO (100-400) for bright conditions
   - Higher ISO (800-3200) for low light
   - Faster shutter (1/500+) for action shots
   - Slower shutter (1/60-) for low light/motion blur

2. **Portrait Mode**: Enable for beautiful bokeh effects
   - Works best with face detection
   - Stand 2-5 feet from subject
   - Ensure good lighting

3. **Grid Overlay**: Use the rule of thirds
   - Place subjects at intersection points
   - Align horizons with grid lines

4. **White Balance**: Adjust for accurate colors
   - Tungsten (3000K): Indoor warm lighting
   - Daylight (5500K): Outdoor/natural light
   - Cloudy (6500K): Overcast conditions

### Editing Tips

1. **Auto-Enhance**: Start with AI auto-enhance for quick improvements
2. **Subtle Adjustments**: Keep brightness/contrast changes under ±0.3
3. **Filters**: Apply before other adjustments for best results
4. **Save Original**: Edits create new files, originals are preserved

## Troubleshooting

### Camera Not Working
- Check permissions in device settings
- Restart the app
- Try switching between front/back cameras

### Photos Not Saving
- Verify storage permission is granted
- Check available storage space
- Try capturing again

### Performance Issues
- Close other apps running in background
- Reduce image resolution in settings
- Clear app cache if needed

### Build Issues
- Run `flutter clean`
- Run `flutter pub get`
- Delete `build` folder
- Restart your IDE

## Getting Help

If you encounter any issues:

1. Check the [FAQ](#) section
2. Search existing [GitHub Issues](https://github.com/harisrovca/camaroo/issues)
3. Ask in [Discussions](https://github.com/harisrovca/camaroo/discussions)
4. Open a [new issue](https://github.com/harisrovca/camaroo/issues/new)

## Next Steps

- Explore all camera controls
- Try different filters and effects
- Create albums to organize your photos
- Experiment with AI features
- Contribute to the project!

## Resources

- [Full Documentation](README.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [Flutter Documentation](https://flutter.dev/docs)

Happy shooting! 📸

#!/bin/bash
set -e

echo ">>> Installing Flutter (stable)..."
git clone https://github.com/flutter/flutter.git --branch stable --depth 1 /opt/flutter
export PATH="/opt/flutter/bin:$PATH"

echo ">>> Flutter version:"
flutter --version

echo ">>> Enabling web support..."
flutter config --enable-web
flutter precache --web

echo ">>> Getting dependencies..."
flutter pub get

echo ">>> Building Flutter web (release)..."
flutter build web --release

echo ">>> Build complete! Output is in build/web"

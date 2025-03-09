#!/bin/bash
# Script to update Dart Board to the latest Flutter version

echo "🔄 Updating Dart Board to the latest Flutter version"

# Step 1: Bootstrap the monorepo with Melos
echo "📦 Bootstrapping the monorepo with Melos..."
melos bootstrap

# Step 2: Clean up any cached dependencies
echo "🧹 Cleaning up cached dependencies..."
flutter clean

# Step 3: Update all dependencies in the monorepo
echo "⬆️ Updating dependencies for all packages..."
melos exec -- "flutter pub upgrade --major-versions"

# Step 4: Run the analyzer to verify no issues
echo "🔍 Running analyzer to check for issues..."
melos analyze || echo "⚠️ Some analysis issues found. Please fix them manually."

# Step 5: Verify dependencies
echo "✅ Verifying dependency constraints..."
melos exec -- "flutter pub outdated"

echo "✨ Dart Board updated to the latest Flutter version!"
echo "🔔 Note: You may need to manually fix any code that uses deprecated APIs."
echo "🧪 Run tests and example apps to verify everything works correctly."

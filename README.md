# Gifster for macOS

![App Logo](Gifster/Assets.xcassets/gifsterlogo.imageset/gifsterlogo.png)

**Gifster** is a lightweight macOS application that allows users to create animated GIFs from selected image files. It's built entirely with SwiftUI and the native macOS SDK — no external dependencies required.

## Features

- Import images from your Mac
- Reorder or remove images before exporting
- Adjust frame delay and loop count
- Export high-quality GIFs directly to disk
- Simple, minimal, and native macOS UI

## Requirements

- macOS 12.0 or later
- Xcode 14+
- Swift 5.7+

## Installation

-- to simply install and run -->

1. Download the app's zip file from the releases page of the repository.
2. Simply extract and run the app.

-- to build from source -->

1. Download XCode or a compatible IDE

XCode - https://apps.apple.com/us/app/xcode/id497799835?mt=12

2. Open terminal

3. Make sure you have git installed (also homebrew to install git)

install homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
install git

```bash
brew install git
```

4. Create your project directory

```bash

mkdir -p /Users/YOUR_USERNAME/xcodeprojects/

cd /Users/YOUR_USERNAME/xcodeprojects/

```

5. Clone the repository into your project folder:

```bash

git clone https://github.com/ccarsonc/Gifster.git

```
6. Switch to the downloaded Gifster directory and open the XCode project

```bash

cd Gifster
open Gifster.xcodeproj

```

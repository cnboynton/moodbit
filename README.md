# Moodbit

A macOS input method that lets you insert emojis using shortcodes

## How It Works

1. Press space, then type `:` to start emoji collection
2. Type your emoji shortcode (e.g., `fire`, `happy`)
3. Press space to insert the emoji

Example: `[space]:fire[space]` → 🔥

## Installation

### Requirements

- macOS 11.5+
- Xcode 13+
- Swift 5.5+

### Setup

1. Open the project in Xcode
2. Run the project
3. In Terminal: `sudo chmod -R 777 /Library/Input\ Methods`
4. Go to **System Settings** → **Keyboard** → **Input Sources**
5. Click **+** and add **Moodbit** under English
6. Select Moodbit from the menu bar input selector

## Adding Custom Emojis

Edit `sampleEmojis` in `InputController.swift`:

```swift
var sampleEmojis: [String: String] = [
    ":fire": "🔥",
    ":happy": "😆",
    ":wave": "👋",
    ":heart": "❤️"
]
```

## Build Settings

The project uses custom build settings to install directly to `/Library/Input Methods`:

- Build Products Path (Debug): `/Library/Input Methods`
- `CONFIGURATION_BUILD_DIR`: `/Library/Input Methods`

## Credits

Based on the IMKit sample project template. Original references:

- https://mzp.hatenablog.com/entry/2017/09/17/220320
- https://www.logcg.com/en/archives/2078.html

Build on top of @ensan-hcl's template:
- https://github.com/ensan-hcl/macOS_IMKitSample_2021


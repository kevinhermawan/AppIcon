# AppIcon

A simple Swift utility for managing and retrieving app icon details in iOS.

## Overview

The `AppIcon` struct provides static properties and functions that facilitate seamless interaction with your application's icon settings. With capabilities to check for alternate icon support, determine the current icon, fetch all defined icons, and set an alternate icon.

## Installation

You can add `AppIcon` as a dependency to your project using Swift Package Manager by adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevinhermawan/AppIcon.git", .upToNextMajor(from: "1.0.0"))
]
```

Alternatively, in Xcode:

1. Open your project in Xcode.
2. Click on `File` -> `Swift Packages` -> `Add Package Dependency...`
3. Enter the repository URL: `https://github.com/kevinhermawan/AppIcon.git`
4. Choose the version you want to add. You probably want to add the latest version.
5. Click `Add Package`.

## Usage

```swift
import AppIcon

// Checking if alternate icons are supported
if AppIcon.isSupported {
    print("Alternate icons are supported!")
} else {
    print("Alternate icons are not supported.")
}

// Fetching the current app icon details
if let currentIcon = AppIcon.current {
    print("Current app icon: \(currentIcon.name) - \(currentIcon.imageName)")
} else {
    print("Using default app icon")
}

// Fetching all defined icons
for icon in AppIcon.defined {
    print("\(icon.name) - \(icon.imageName)")
}

// Setting an alternate app icon (for example, "Alternate1")
if let iconToSet = AppIcon.defined.first(where: { $0.name == "Alternate1" }) {
    AppIcon.set(icon: iconToSet) { error in
        if let error = error {
            print("Failed to set app icon: \(error.localizedDescription)")
        } else {
            print("App icon successfully set!")
        }
    }
} else {
    print("Failed to find the specified icon.")
}
```

## License

[MIT License](/LICENSE)

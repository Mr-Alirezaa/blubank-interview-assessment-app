# ḃlubank Interview Assessment App

## Introduction

This app is designed and implemented as was requested in ḃlubank iOS assignment. I chose Swift Structured Concurrency over Combine because it is a newer technology and this app was a proper challenge to test and learn stuff about it.

Since minimum iOS version was mentioned 13.0, I used `UICollectionViewDiffableDataSource` and `UICollectionViewCompositionalLayout` in order to handle layout and updates of data in the collection views in the app. I also extracted the part of the code that could be reused (for example in the future, in app extensions) into a separate Swift Package. (placed in the root of the project.)

I tried my best to stay in the directions of [Human Interface Guideline](https://developer.apple.com/design/human-interface-guidelines/guidelines/overview/) and not overly customize UI elements.

Architecture of the app is (somehow-customized 😅) Clean. Although I haven't written tests, I tried to write a highly testable code.

## Installation

Simply clone the project and run it using Xcode. Dependencies are managed with SPM.

```bash
git clone --branch "1.0.0" https://github.com/Mr-Alirezaa/blubank-interview-assessment-app "Countries" \
    && open "Countries/Countries.xcodeproj" -a Xcode.app
```

## Dependencies

- [SnapKit/SnapKit](https://github.com/SnapKit/SnapKit): Used for writing view constraints in code easily
- [Mr-Alirezaa/swift-localization-backport](https://github.com/Mr-Alirezaa/swift-localization-backport): Used for localizing in-app strings. Works similar to what Apple provides in Foundation from iOS 15.0

# Kelly Stakes iOS

Part of [mchen04/kelly-stakes](https://github.com/mchen04/kelly-stakes), maintained on the default branch `consolidate/kelly-monorepo`.

Native SwiftUI/Combine app with a Foundation calculator, UserDefaults presets and StoreKit 2. Project, shared scheme, StoreKit configuration, three referenced icon PNG filenames, colors, all 24 app Swift sources and useful unit/UI suites retain their relative layout. Bundle ID remains `com.michaelchen.kellystakes`.

On a Mac with full Xcode, from the repository root:

```sh
open apps/ios/KellyCriterion.xcodeproj
xcodebuild -list -project apps/ios/KellyCriterion.xcodeproj
xcodebuild -showdestinations -project apps/ios/KellyCriterion.xcodeproj -scheme KellyCriterion
```

Choose an actually installed simulator, then:

```sh
xcodebuild -project apps/ios/KellyCriterion.xcodeproj -scheme KellyCriterion \
  -destination 'platform=iOS Simulator,id=<installed-simulator-UUID>' \
  -derivedDataPath apps/ios/DerivedData build
xcodebuild -project apps/ios/KellyCriterion.xcodeproj -scheme KellyCriterion \
  -destination 'platform=iOS Simulator,id=<installed-simulator-UUID>' \
  -derivedDataPath apps/ios/DerivedData test
```

These are future Xcode commands, not successful app-build receipts. The project was created with Xcode 16.3. App configurations target iOS 17.6; unit-test configurations target iOS 18.4. Use appropriate SDKs/simulators. Device, accessibility and StoreKit purchases were not exercised; do not run purchases for a consolidation smoke check.

This machine has Command Line Tools, without full Xcode or the `Testing` module. A task-only temporary Swift package can compile seven original Foundation sources (AppConstants, Double/String extensions, KellyCalculator, OddsConverter, InputValidator, KellyCalculation); the original 19-method Swift Testing suite cannot run through its original framework here. Evidence describes any additional assertion-harness execution separately from app validation.

All 19 original test bodies were executed in a task-only native Boolean-assertion harness: 68 of 69 assertions passed. The unchanged engine accepts `++150`, contrary to its retained validation test. This is an inherited defect, not a successful original-framework test run or iOS app build.

[Accessibility checklist](ACCESSIBILITY_TESTING_CHECKLIST.md) remains a manual reference, not a completed certification. Historical README/testing guides, AI scaffolding, user-specific Xcode state and the generated launch screenshot test remain recoverable from `../../archives/kelly-stakes-ios/kelly-stakes-ios.bundle`. Core/feature sources and useful test coverage were retained.

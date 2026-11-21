# auto-maintenance

Android app (ClojureDart + Flutter) that keeps a maintenance diary for cars: a car is identified by its VIN, its
schedule comes from a template, the odometer is read from a photo, and the app reminds what is due next. Everything
stays on the phone as an event log.

- What the app does: [model/event-model.yaml](model/event-model.yaml) (slices with Given/When/Then scenarios),
  [model/event-model.svg](model/event-model.svg), decisions in [model/review-2026-11-21-first-cut.org](model/review-2026-11-21-first-cut.org).
- How to work on it: [AGENTS.md](AGENTS.md).

## Requirements

- Clojure CLI, JDK 21, Babashka (`bb`).
- Flutter **3.47.9** in `~/sdk/flutter-3.47.9` — not 3.50: ClojureDart hangs with Flutter 3.50
  ([ClojureDart#389](https://github.com/tensegritics/ClojureDart/issues/389)). The `bb` tasks put it first on `PATH`,
  so the system Flutter can stay at any version.
- Android SDK in `~/Android/Sdk` (platform 36), a phone with USB debugging or wireless debugging enabled.

## Tasks

```
bb tasks          # list
bb test           # compile + run tests, including the model check (no device)
bb dev            # run on a device with hot reload and a socket REPL (bb dev -d <device-id>)
bb apk            # build/app/outputs/flutter-apk/app-debug.apk
bb install        # build and adb install on the connected phone
bb doctor         # flutter doctor with the pinned Flutter
```

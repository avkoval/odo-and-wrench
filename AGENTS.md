# auto-maintenance — notes for agents

ClojureDart + Flutter Android app, event-sourced, all data on the phone. Read [README.md](README.md) for the tasks.

## Model first

The approved model is [model/event-model.yaml](model/event-model.yaml); decisions D1–D13 are in
[model/review-2026-11-21-first-cut.org](model/review-2026-11-21-first-cut.org). New behaviour is first a slice in the
model with scenarios, reviewed by the user (skill `event-model`), then implemented (skill `es-slice`). When code and
a scenario disagree, find which one is wrong and ask; an approved scenario is the contract.

## Layout

- `src/auto_maintenance/main.cljd` — Flutter entry point (screens).
- `src/auto_maintenance/slices.cljd` — registry of implemented slices: `{:decide (fn [given-events command])}` for
  state changes, `{:project (fn [events params])}` for read models. Domain code has no Flutter imports.
- `test/auto_maintenance/model_test.cljd` — the model check: runs every scenario of every registered slice and
  prints `model check: N/21 slices implemented`. A slice is done when it is registered and its scenarios pass.
- `lib/main.dart` only re-exports the compiled main; `lib/cljd-out/` and `test/cljd-out/` are build output.

## Tooling rules

- Always go through `bb` tasks (or put `~/sdk/flutter-3.47.9/bin` first on `PATH`): the system Flutter 3.50 makes
  `clj -M:cljd compile` hang forever after "Compiling cljd.core to Dart 3" (ClojureDart#389).
- `bb test` runs on the host with `flutter test`; no phone needed. Finish every change with a green `bb test`.
- `bb dev` starts the watcher: compiles on save, hot reloads the app on the device, and prints
  `ClojureDart REPL listening on port N` (also in `REPL.lock`, or `bb repl-port`) — a socket REPL, not nREPL:
  `nc localhost N`, or `M-x cljd-repl` in the user's Emacs (inf-clojure, inline results).
  `(pick!)` selects a widget on the phone screen, `(mount! w)` replaces it. The REPL is beta and can lag.
- Python, when needed, is `python` (never `python3`).

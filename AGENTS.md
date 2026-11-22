# auto-maintenance — notes for agents

ClojureDart + Flutter Android app, event-sourced, all data on the phone. Read [README.md](README.md) for the tasks.

## Development is REPL-driven

Changes reach the running app through its REPL, form by form, and are checked there
before the file is considered done. The user's `bb dev` (ClojureDart flutter watcher on the phone) is the running
system; its socket REPL port is in `REPL.lock`.

1. Evaluate in the live app with `bb repl-eval '<one form>'` (prints the result). Use it to look at data
   (`(count @auto-maintenance.app/!events)`, `(auto-maintenance.app/due-list @auto-maintenance.app/!events "forester")`),
   to try a command against the real log (`(auto-maintenance.domain.decide/handle @auto-maintenance.app/!events {...})`
   — pure, appends nothing) and to load a changed function before saving it.
2. Save the file; the watcher recompiles and hot-reloads. Hot reload updates function bodies but does NOT re-run
   top-level forms, so: no `defmulti`/`defmethod` (dispatch with `case`), no new top-level state that code needs —
   or evaluate that top-level form through the REPL.
3. Finish with `bb test` (model check + unit tests, runs in `target/test-copy` while `bb dev` holds the lock).

Keeping the REPL alive (ClojureDart REPL is beta, ClojureDart#364): one thread in the watcher routes the app's
output to the REPL clients and acknowledges each evaluation. If it writes to a client socket that is already closed,
it dies with "Broken pipe" and no evaluation is ever acknowledged again — every session hangs.
- Never connect before the app is ready. The watcher writes `REPL.lock` when its server starts, long before the app
  runs; a session opened then evaluates its `(ns cljd.user …)` under the global compiler lock, the hot reload goes
  nowhere, the lock is held forever and even file recompilation stops (no more "Performing hot reload..."). `bb dev`
  records the state in `target/repl-state` (ready after "REPL listening" / "Reloaded … libraries", reloading,
  restarting) and `bb repl-eval` refuses unless it is ready — always start the app with `bb dev`.
- One form per `bb repl-eval`; it disconnects only after the result and the next prompt arrived. Never kill a
  client mid-evaluation, never send anything you will not wait for (`:repl/quit` is evaluated like any form), and do
  not hot-restart (`R`) while an evaluation is pending.
- The watcher tracks Flutter's output: after "Performing hot reload..." it waits for "Reloaded N of M libraries".
  When Flutter rejects or fails a hot reload (an incompatible Dart change, e.g. turning a def into a function),
  that line never comes, the watcher stays "reloading" forever and no REPL evaluation is ever sent — even `R` does
  not get it out. Saving files triggers hot reloads in the user's app, so batch file saves and avoid changes Dart
  cannot hot-reload while the REPL is in use.
- A REPL that prints nothing, not even its banner, is wedged: only restarting `bb dev` helps. Ask the user to do it;
  never start or stop the user's `bb dev` yourself.

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

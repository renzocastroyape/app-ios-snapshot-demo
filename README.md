# app-ios-snapshot-demo

Modular iOS demo (Tuist) with SwiftLint, unit tests and snapshot tests checked on every pull request.

## Requirements
- Xcode 27.1 (see `.xcode-version`)
- [mise](https://mise.jdx.dev) (installs the pinned `tuist` and `swiftlint`)
- iOS 15.6 deployment target

## Modules
| Module | Description |
| --- | --- |
| `DesignSystem` | Shared colors and components (UIKit and SwiftUI) |
| `FeatureUIKit` | Items list and detail flow in UIKit |
| `FeatureSwiftUI` | Login flow in SwiftUI |

`App` only composes the two features. Each module has its own `<Module>Tests` and `<Module>SnapshotTests` targets.

## Commands
| Command | Description |
| --- | --- |
| `make bootstrap` | Install tools and dependencies |
| `make generate` | Generate the Xcode workspace |
| `make lint` | Run SwiftLint (strict) |
| `make test-unit` | Run unit tests |
| `make test-snapshot` | Verify snapshots |
| `make snapshots-record` | Re-record snapshots and verify them |
| `make test` | Unit and snapshot tests |

The simulator is configurable with `SIMULATOR_NAME` and `SIMULATOR_OS` (defaults: iPhone 17, iOS 27.2 locally; CI uses iOS 27.0).

CI runs all jobs on the `xcode-27` runner image (public preview), which ships Xcode 27.1 and the iOS 27.0 simulator.

## Snapshots
- References live in each module under `SnapshotTests/__Snapshots__/`.
- The reference runtime is the one used in CI (iOS 27.0). Snapshots recorded locally on a different runtime can differ from CI.
- Tests never record by default: a missing or different snapshot fails the run.

## Pull request flow
`PR Checks` runs `lint`, `unit-tests` and `snapshot-tests`.

Changes under `__Snapshots__/` require review from `@renzocastroyape` (see `.github/CODEOWNERS`).

1. If snapshots were pushed with the PR, `snapshot-tests` verifies them and the reviewer approves the image diff.
2. If the UI changed and snapshots were not pushed, `snapshot-tests` fails, uploads the differences and new snapshots as the `snapshot-failures` artifact and comments on the PR.
3. After reviewing them, `@renzocastroyape` comments `/update-snapshots` or adds the `approve-snapshots` label. `Update Snapshots` re-records the snapshots in CI, commits them to the PR branch and dispatches `PR Checks` again.

## Repository settings
- Require the `lint`, `unit-tests` and `snapshot-tests` checks on the protected branch.
- Enable "Require review from Code Owners".
- Allow GitHub Actions to create and approve pull requests / write to contents (workflow permissions), and create the `approve-snapshots` label.
- If "Dismiss stale pull request approvals" is on, the reviewer must approve again after the snapshot commit.

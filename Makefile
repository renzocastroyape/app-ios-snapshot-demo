SIMULATOR_NAME ?= iPhone 17
SIMULATOR_OS ?= 27.0
DESTINATION := platform=iOS Simulator,name=$(SIMULATOR_NAME),OS=$(SIMULATOR_OS)

WORKSPACE := SnapshotDemo.xcworkspace
BUILD_DIR := build
TUIST := mise exec -- tuist
SWIFTLINT := mise exec -- swiftlint

.PHONY: bootstrap generate lint test test-unit test-snapshot snapshots-record clean

bootstrap:
	mise install
	$(TUIST) install

generate:
	$(TUIST) generate --no-open

lint:
	$(SWIFTLINT) lint --strict

test-unit: generate
	rm -rf $(BUILD_DIR)/UnitTests.xcresult
	set -o pipefail && xcodebuild test \
		-workspace $(WORKSPACE) \
		-scheme UnitTests \
		-destination '$(DESTINATION)' \
		-resultBundlePath $(BUILD_DIR)/UnitTests.xcresult

test-snapshot: generate
	rm -rf $(BUILD_DIR)/SnapshotTests.xcresult
	set -o pipefail && xcodebuild test \
		-workspace $(WORKSPACE) \
		-scheme SnapshotTests \
		-destination '$(DESTINATION)' \
		-resultBundlePath $(BUILD_DIR)/SnapshotTests.xcresult

test: test-unit test-snapshot

# Recording makes the run fail by design, so the result comes from the verification run.
snapshots-record: generate
	rm -rf $(BUILD_DIR)/SnapshotsRecord.xcresult
	-TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all xcodebuild test \
		-workspace $(WORKSPACE) \
		-scheme SnapshotTests \
		-destination '$(DESTINATION)' \
		-resultBundlePath $(BUILD_DIR)/SnapshotsRecord.xcresult
	$(MAKE) test-snapshot

clean:
	rm -rf $(BUILD_DIR) Derived $(WORKSPACE) SnapshotDemo.xcodeproj

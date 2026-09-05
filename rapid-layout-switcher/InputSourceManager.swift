import Carbon
import Combine
import Foundation

@MainActor
final class InputSourceManager: NSObject, ObservableObject {
    @Published private(set) var sources: [KeyboardInputSource] = []

    private var sourceCache: [String: TISInputSource] = [:]

    override init() {
        super.init()
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(enabledInputSourcesChanged),
            name: Notification.Name(kTISNotifyEnabledKeyboardInputSourcesChanged as String),
            object: nil
        )
        refresh()
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func refresh() {
        guard let list = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] else {
            sourceCache = [:]
            sources = []
            return
        }

        var discovered: [KeyboardInputSource] = []
        var discoveredSources: [String: TISInputSource] = [:]
        var seenIDs: Set<String> = []

        for source in list {
            guard
                boolProperty(source, key: kTISPropertyInputSourceIsEnabled),
                boolProperty(source, key: kTISPropertyInputSourceIsSelectCapable),
                stringProperty(source, key: kTISPropertyInputSourceCategory) == kTISCategoryKeyboardInputSource as String,
                let id = stringProperty(source, key: kTISPropertyInputSourceID),
                let name = stringProperty(source, key: kTISPropertyLocalizedName),
                seenIDs.insert(id).inserted
            else {
                continue
            }

            discovered.append(KeyboardInputSource(id: id, displayName: name))
            discoveredSources[id] = source
        }

        sourceCache = discoveredSources
        sources = discovered.sorted {
            $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
        }
    }

    func choices(including selectedID: String) -> [KeyboardInputSource] {
        guard !sources.contains(where: { $0.id == selectedID }) else {
            return sources
        }

        return [
            KeyboardInputSource(
                id: selectedID,
                displayName: "Unavailable — \(selectedID)"
            )
        ] + sources
    }

    func selectInputSource(id: String) throws {
        guard let source = sourceCache[id] else {
            throw InputSourceError.notAvailable(id)
        }

        let status = TISSelectInputSource(source)
        guard status == noErr else {
            throw InputSourceError.selectionFailed(id, status)
        }
    }

    @objc private func enabledInputSourcesChanged() {
        refresh()
    }

    private func stringProperty(_ source: TISInputSource, key: CFString) -> String? {
        guard let pointer = TISGetInputSourceProperty(source, key) else {
            return nil
        }
        return Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
    }

    private func boolProperty(_ source: TISInputSource, key: CFString) -> Bool {
        guard let pointer = TISGetInputSourceProperty(source, key) else {
            return false
        }
        let value = Unmanaged<CFBoolean>.fromOpaque(pointer).takeUnretainedValue()
        return CFBooleanGetValue(value)
    }
}

enum InputSourceError: LocalizedError {
    case notAvailable(String)
    case selectionFailed(String, OSStatus)

    var errorDescription: String? {
        switch self {
        case .notAvailable(let id):
            "The input source “\(id)” is not enabled."
        case .selectionFailed(let id, let status):
            "Could not select “\(id)” (error \(status))."
        }
    }
}

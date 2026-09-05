import Carbon
import Combine
import Foundation

@MainActor
final class InputSourceManager: NSObject, ObservableObject {
    @Published private(set) var sources: [KeyboardInputSource] = []
    @Published private(set) var currentSource: KeyboardInputSource?

    private var sourceCache: [String: TISInputSource] = [:]

    override init() {
        super.init()
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(enabledInputSourcesChanged),
            name: Notification.Name(kTISNotifyEnabledKeyboardInputSourcesChanged as String),
            object: nil
        )
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(selectedInputSourceChanged),
            name: Notification.Name(kTISNotifySelectedKeyboardInputSourceChanged as String),
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
            refreshCurrentSource()
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
                let inputSource = keyboardInputSource(from: source),
                seenIDs.insert(inputSource.id).inserted
            else {
                continue
            }

            discovered.append(inputSource)
            discoveredSources[inputSource.id] = source
        }

        sourceCache = discoveredSources
        sources = discovered.sorted {
            $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
        }
        refreshCurrentSource()
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
        refreshCurrentSource()
    }

    @objc private func enabledInputSourcesChanged() {
        refresh()
    }

    @objc private func selectedInputSourceChanged() {
        refreshCurrentSource()
    }

    private func refreshCurrentSource() {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
            currentSource = nil
            return
        }
        currentSource = keyboardInputSource(from: source)
    }

    private func keyboardInputSource(from source: TISInputSource) -> KeyboardInputSource? {
        guard
            let id = stringProperty(source, key: kTISPropertyInputSourceID),
            let name = stringProperty(source, key: kTISPropertyLocalizedName)
        else {
            return nil
        }

        return KeyboardInputSource(
            id: id,
            displayName: name,
            languageCode: languageCodeProperty(source)
        )
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

    private func languageCodeProperty(_ source: TISInputSource) -> String? {
        guard let pointer = TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages) else {
            return nil
        }

        let languages = Unmanaged<CFArray>.fromOpaque(pointer).takeUnretainedValue() as? [String]
        guard let identifier = languages?.first else {
            return nil
        }

        return Locale(identifier: identifier).language.languageCode?.identifier.uppercased()
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

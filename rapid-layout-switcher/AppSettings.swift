import Combine
import CoreGraphics
import Foundation

@MainActor
final class AppSettings: ObservableObject {
    @Published var leftTrigger: ModifierKey {
        didSet { defaults.set(leftTrigger.rawValue, forKey: Keys.leftTrigger) }
    }

    @Published var rightTrigger: ModifierKey {
        didSet { defaults.set(rightTrigger.rawValue, forKey: Keys.rightTrigger) }
    }

    @Published var leftInputSourceID: String {
        didSet { defaults.set(leftInputSourceID, forKey: Keys.leftInputSourceID) }
    }

    @Published var rightInputSourceID: String {
        didSet { defaults.set(rightInputSourceID, forKey: Keys.rightInputSourceID) }
    }

    @Published var showsInputSourceNameInMenuBar: Bool {
        didSet { defaults.set(showsInputSourceNameInMenuBar, forKey: Keys.showsInputSourceNameInMenuBar) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        leftTrigger = ModifierKey(rawValue: defaults.string(forKey: Keys.leftTrigger) ?? "") ?? .command
        rightTrigger = ModifierKey(rawValue: defaults.string(forKey: Keys.rightTrigger) ?? "") ?? .command
        leftInputSourceID = defaults.string(forKey: Keys.leftInputSourceID) ?? "com.apple.keylayout.ABC"
        rightInputSourceID = defaults.string(forKey: Keys.rightInputSourceID) ?? "com.apple.keylayout.ABC"
        showsInputSourceNameInMenuBar = defaults.bool(forKey: Keys.showsInputSourceNameInMenuBar)
    }

    var triggerConfiguration: TriggerConfiguration {
        TriggerConfiguration(left: leftTrigger, right: rightTrigger)
    }

    func inputSourceID(for side: TriggerSide) -> String {
        switch side {
        case .left: leftInputSourceID
        case .right: rightInputSourceID
        }
    }

    private enum Keys {
        static let leftTrigger = "leftTrigger"
        static let rightTrigger = "rightTrigger"
        static let leftInputSourceID = "leftInputSourceID"
        static let rightInputSourceID = "rightInputSourceID"
        static let showsInputSourceNameInMenuBar = "showsInputSourceNameInMenuBar"
    }
}

enum TriggerSide: String, Sendable {
    case left
    case right
}

enum ModifierKey: String, CaseIterable, Identifiable, Sendable {
    case command
    case option
    case control

    var id: Self { self }

    var displayName: String {
        switch self {
        case .command: "Command"
        case .option: "Option"
        case .control: "Control"
        }
    }

    var symbol: String {
        switch self {
        case .command: "⌘"
        case .option: "⌥"
        case .control: "⌃"
        }
    }

    var eventFlag: CGEventFlags {
        switch self {
        case .command: .maskCommand
        case .option: .maskAlternate
        case .control: .maskControl
        }
    }

    func keyCode(for side: TriggerSide) -> Int64 {
        switch (self, side) {
        case (.command, .left): 0x37
        case (.command, .right): 0x36
        case (.option, .left): 0x3A
        case (.option, .right): 0x3D
        case (.control, .left): 0x3B
        case (.control, .right): 0x3E
        }
    }

    static func modifier(forKeyCode keyCode: Int64) -> ModifierKey? {
        switch keyCode {
        case 0x36, 0x37: .command
        case 0x3A, 0x3D: .option
        case 0x3B, 0x3E: .control
        default: nil
        }
    }
}

struct TriggerConfiguration: Sendable {
    let left: ModifierKey
    let right: ModifierKey

    func side(for keyCode: Int64) -> TriggerSide? {
        if keyCode == left.keyCode(for: .left) {
            return .left
        }
        if keyCode == right.keyCode(for: .right) {
            return .right
        }
        return nil
    }
}

import CoreGraphics
import Foundation

struct CommandTapDetector {
    private struct Candidate {
        let side: TriggerSide
        let keyCode: Int64
    }

    private var candidate: Candidate?
    private var pressedModifierKeyCodes: Set<Int64> = []

    mutating func handleFlagsChanged(
        keyCode: Int64,
        flags: CGEventFlags,
        configuration: TriggerConfiguration
    ) -> TriggerSide? {
        guard let modifier = modifierForPhysicalKey(keyCode) else {
            candidate = nil
            return nil
        }

        let isDown: Bool
        if !flags.contains(modifier.eventFlag) {
            isDown = false
        } else {
            // Modifier flags do not distinguish left from right. Toggling our
            // physical-key set lets us recognize a release while the matching
            // modifier on the other side remains held.
            isDown = !pressedModifierKeyCodes.contains(keyCode)
        }

        if isDown {
            let hadAnotherModifierDown = !pressedModifierKeyCodes.isEmpty
            pressedModifierKeyCodes.insert(keyCode)

            if candidate != nil {
                candidate = nil
                return nil
            }

            guard
                !hadAnotherModifierDown,
                !hasDisallowedModifier(in: flags, trigger: modifier),
                let side = configuration.side(for: keyCode)
            else {
                return nil
            }

            candidate = Candidate(side: side, keyCode: keyCode)
            return nil
        }

        pressedModifierKeyCodes.remove(keyCode)

        guard let candidate else {
            return nil
        }

        self.candidate = nil
        return candidate.keyCode == keyCode ? candidate.side : nil
    }

    mutating func cancelPendingTrigger() {
        candidate = nil
    }

    mutating func reset() {
        candidate = nil
        pressedModifierKeyCodes.removeAll()
    }

    private func modifierForPhysicalKey(_ keyCode: Int64) -> PhysicalModifier? {
        PhysicalModifier(keyCode: keyCode)
    }

    private func hasDisallowedModifier(
        in flags: CGEventFlags,
        trigger: PhysicalModifier
    ) -> Bool {
        let relevant: CGEventFlags = [
            .maskCommand,
            .maskAlternate,
            .maskControl,
            .maskShift,
            .maskSecondaryFn
        ]
        let allowed = trigger.eventFlag
        return !flags.intersection(relevant).subtracting(allowed).isEmpty
    }
}

private enum PhysicalModifier {
    case command
    case option
    case control
    case shift
    case function

    init?(keyCode: Int64) {
        switch keyCode {
        case 0x36, 0x37: self = .command
        case 0x3A, 0x3D: self = .option
        case 0x3B, 0x3E: self = .control
        case 0x38, 0x3C: self = .shift
        case 0x3F: self = .function
        default: return nil
        }
    }

    var eventFlag: CGEventFlags {
        switch self {
        case .command: .maskCommand
        case .option: .maskAlternate
        case .control: .maskControl
        case .shift: .maskShift
        case .function: .maskSecondaryFn
        }
    }
}

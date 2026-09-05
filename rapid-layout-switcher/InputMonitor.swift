import ApplicationServices
import Foundation

@MainActor
enum InputMonitorStatus: Equatable {
    case stopped
    case permissionRequired
    case running
    case failed(String)

    var message: String {
        switch self {
        case .stopped: "Stopped"
        case .permissionRequired: "Input Monitoring permission required"
        case .running: "Running"
        case .failed(let message): message
        }
    }
}

@MainActor
final class InputMonitor {
    typealias ConfigurationProvider = () -> TriggerConfiguration
    typealias TriggerHandler = (TriggerSide) -> Void
    typealias StatusHandler = (InputMonitorStatus) -> Void

    private let configuration: ConfigurationProvider
    private let onTrigger: TriggerHandler
    private let onStatusChange: StatusHandler

    private var detector = CommandTapDetector()
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    init(
        configuration: @escaping ConfigurationProvider,
        onTrigger: @escaping TriggerHandler,
        onStatusChange: @escaping StatusHandler
    ) {
        self.configuration = configuration
        self.onTrigger = onTrigger
        self.onStatusChange = onStatusChange
    }


    func start(requestPermission: Bool) {
        stop()

        var hasPermission = CGPreflightListenEventAccess()
        if !hasPermission, requestPermission {
            hasPermission = CGRequestListenEventAccess()
        }

        guard hasPermission else {
            onStatusChange(.permissionRequired)
            return
        }

        let eventTypes: [CGEventType] = [
            .flagsChanged,
            .keyDown,
            .leftMouseDown,
            .rightMouseDown,
            .otherMouseDown,
            .leftMouseDragged,
            .rightMouseDragged,
            .otherMouseDragged,
            .scrollWheel
        ]
        let mask = eventTypes.reduce(CGEventMask(0)) {
            $0 | (CGEventMask(1) << $1.rawValue)
        }

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { _, type, event, userInfo in
                guard let userInfo else {
                    return Unmanaged.passUnretained(event)
                }

                let monitor = Unmanaged<InputMonitor>
                    .fromOpaque(userInfo)
                    .takeUnretainedValue()

                MainActor.assumeIsolated {
                    monitor.receive(type: type, event: event)
                }

                return Unmanaged.passUnretained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            onStatusChange(.failed("Could not create the input event monitor"))
            return
        }

        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        eventTap = tap
        runLoopSource = source
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        onStatusChange(.running)
    }

    func stop() {
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
        detector.reset()
    }

    private func receive(type: CGEventType, event: CGEvent) {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: true)
                onStatusChange(.running)
            }
            return
        }

        if type == .flagsChanged {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            if let side = detector.handleFlagsChanged(
                keyCode: keyCode,
                flags: event.flags,
                configuration: configuration()
            ) {
                onTrigger(side)
            }
        } else {
            detector.cancelPendingTrigger()
        }
    }
}

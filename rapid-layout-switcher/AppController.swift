import AppKit
import Combine
import ServiceManagement

@MainActor
final class AppController: ObservableObject {
    let settings: AppSettings
    let inputSources: InputSourceManager

    @Published private(set) var monitorStatus: InputMonitorStatus = .stopped
    @Published private(set) var operationError: String?
    @Published private(set) var launchAtLoginEnabled = false

    private var monitor: InputMonitor!

    init() {
        let settings = AppSettings()
        let inputSources = InputSourceManager()
        self.settings = settings
        self.inputSources = inputSources

        monitor = InputMonitor(
            configuration: { settings.triggerConfiguration },
            onTrigger: { [weak self] side in
                self?.selectInputSource(for: side)
            },
            onStatusChange: { [weak self] status in
                self?.monitorStatus = status
            }
        )

        refreshLaunchAtLoginStatus()
        monitor.start(requestPermission: true)
    }

    var statusMessage: String {
        operationError ?? monitorStatus.message
    }

    var isRunning: Bool {
        monitorStatus == .running
    }

    func refresh() {
        inputSources.refresh()
        refreshLaunchAtLoginStatus()
        if monitorStatus == .permissionRequired, CGPreflightListenEventAccess() {
            monitor.start(requestPermission: false)
        }
    }

    func retryInputMonitoring() {
        operationError = nil
        monitor.start(requestPermission: true)
    }

    func stop() {
        monitor.stop()
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        operationError = nil
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            operationError = "Could not update Start at Login: \(error.localizedDescription)"
        }
        refreshLaunchAtLoginStatus()
    }

    func openInputMonitoringSettings() {
        guard let url = URL(
            string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
        ) else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    private func selectInputSource(for side: TriggerSide) {
        operationError = nil
        let id = settings.inputSourceID(for: side)
        do {
            try inputSources.selectInputSource(id: id)
        } catch {
            operationError = error.localizedDescription
        }
    }

    private func refreshLaunchAtLoginStatus() {
        launchAtLoginEnabled = SMAppService.mainApp.status == .enabled
    }
}

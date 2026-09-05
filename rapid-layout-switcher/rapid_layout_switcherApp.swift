import AppKit
import SwiftUI

@main
struct RapidLayoutSwitcherApp: App {
    @StateObject private var controller = AppController()

    var body: some Scene {
        Window("Rapid Layout Switcher", id: "settings") {
            ContentView(controller: controller)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)

        MenuBarExtra {
            MenuBarContent(controller: controller)
        } label: {
            Label(
                "Rapid Layout Switcher",
                systemImage: controller.isRunning ? "keyboard.fill" : "keyboard"
            )
        }
        .menuBarExtraStyle(.menu)
    }
}

private struct MenuBarContent: View {
    @ObservedObject var controller: AppController
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Text(controller.statusMessage)

        Divider()

        Button("Open Settings…") {
            openWindow(id: "settings")
            NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut(",")

        Toggle(
            "Start at Login",
            isOn: Binding(
                get: { controller.launchAtLoginEnabled },
                set: { controller.setLaunchAtLogin($0) }
            )
        )

        if !controller.isRunning {
            Divider()

            Button("Open Input Monitoring Settings…") {
                controller.openInputMonitoringSettings()
            }

            Button("Retry Input Monitoring") {
                controller.retryInputMonitoring()
            }
        }

        Divider()

        Button("Quit Rapid Layout Switcher") {
            controller.stop()
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

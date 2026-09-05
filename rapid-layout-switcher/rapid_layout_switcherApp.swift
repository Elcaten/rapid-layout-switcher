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
            MenuBarLabel(controller: controller)
        }
        .menuBarExtraStyle(.menu)
    }
}

private struct MenuBarLabel: View {
    @ObservedObject var controller: AppController
    @ObservedObject private var inputSources: InputSourceManager
    @ObservedObject private var settings: AppSettings

    init(controller: AppController) {
        self.controller = controller
        inputSources = controller.inputSources
        settings = controller.settings
    }

    var body: some View {
        HStack(spacing: 7) {
            let icon = LanguageCodeIcon.image(
                for: inputSources.currentSource?.languageCode
            )

            Image(nsImage: icon)
                .resizable()
                .interpolation(.high)
                .frame(width: icon.size.width, height: icon.size.height)
                .accessibilityLabel(
                    "Input source language \(inputSources.currentSource?.languageCode ?? "unknown")"
                )

            if settings.showsInputSourceNameInMenuBar {
                Text(inputSources.currentSource?.displayName ?? "Unknown")
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .id(
            "\(settings.showsInputSourceNameInMenuBar)-"
                + (inputSources.currentSource?.id ?? "unknown")
        )
    }
}

private struct MenuBarContent: View {
    @ObservedObject var controller: AppController
    @ObservedObject private var settings: AppSettings
    @Environment(\.openWindow) private var openWindow

    init(controller: AppController) {
        self.controller = controller
        settings = controller.settings
    }

    var body: some View {
        Text("Status: \(controller.statusMessage)")

        Divider()

        Button("Open Settings…") {
            openWindow(id: "settings")
            NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut(",")

        Button(
            settings.showsInputSourceNameInMenuBar
                ? "Hide Input Source Name"
                : "Show Input Source Name"
        ) {
            settings.showsInputSourceNameInMenuBar.toggle()
        }

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

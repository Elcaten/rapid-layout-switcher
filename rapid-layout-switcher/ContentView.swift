import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: AppController
    @ObservedObject private var settings: AppSettings
    @ObservedObject private var inputSources: InputSourceManager

    init(controller: AppController) {
        self.controller = controller
        settings = controller.settings
        inputSources = controller.inputSources
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Grid(horizontalSpacing: 18, verticalSpacing: 18) {
                GridRow {
                    triggerPicker(
                        title: "Left triggering key",
                        selection: $settings.leftTrigger
                    )
                    triggerPicker(
                        title: "Right triggering key",
                        selection: $settings.rightTrigger
                    )
                }

                GridRow {
                    layoutPicker(
                        title: "Left keyboard layout",
                        selection: $settings.leftInputSourceID
                    )
                    layoutPicker(
                        title: "Right keyboard layout",
                        selection: $settings.rightInputSourceID
                    )
                }
            }

            Toggle(
                "Show input source name next to language code",
                isOn: $settings.showsInputSourceNameInMenuBar
            )

            Divider()

            HStack(spacing: 8) {
                Image(systemName: controller.isRunning ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(controller.isRunning ? .green : .orange)
                Text(controller.statusMessage)
                    .lineLimit(2)

                Spacer()

                if !controller.isRunning {
                    Button("Open System Settings") {
                        controller.openInputMonitoringSettings()
                    }
                    Button("Retry") {
                        controller.retryInputMonitoring()
                    }
                }
            }
            .font(.callout)
        }
        .padding(22)
        .frame(width: 560)
        .onAppear {
            controller.refresh()
        }
    }


    private func triggerPicker(
        title: String,
        selection: Binding<ModifierKey>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Picker(title, selection: selection) {
                ForEach(ModifierKey.allCases) { modifier in
                    Text("\(modifier.symbol)  \(modifier.displayName)")
                        .tag(modifier)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 10))
    }

    private func layoutPicker(
        title: String,
        selection: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Picker(title, selection: selection) {
                ForEach(inputSources.choices(including: selection.wrappedValue)) { source in
                    Text(source.displayName)
                        .tag(source.id)
                        .help(source.id)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView(controller: AppController())
}

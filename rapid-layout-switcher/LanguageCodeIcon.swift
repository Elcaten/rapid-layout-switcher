import AppKit

@MainActor
enum LanguageCodeIcon {
    private static var cache: [String: NSImage] = [:]

    static func image(for languageCode: String?) -> NSImage {
        let code = normalized(languageCode)
        if let cached = cache[code] {
            return cached
        }

        let font = NSFont.monospacedSystemFont(ofSize: 12, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.white
        ]
        let textSize = (code as NSString).size(withAttributes: attributes)
        let imageSize = NSSize(
            width: max(22, ceil(textSize.width) + 10),
            height: 16
        )

        let image = NSImage(size: imageSize, flipped: false) { rect in
            NSColor.black.setFill()
            NSBezierPath(
                roundedRect: rect,
                xRadius: 3,
                yRadius: 3
            ).fill()

            guard let context = NSGraphicsContext.current else {
                return false
            }

            context.saveGraphicsState()
            context.compositingOperation = .clear
            (code as NSString).draw(
                at: NSPoint(
                    x: floor((rect.width - textSize.width) / 2),
                    y: floor((rect.height - textSize.height) / 2) + 1
                ),
                withAttributes: attributes
            )
            context.restoreGraphicsState()
            return true
        }

        image.isTemplate = true
        cache[code] = image
        return image
    }

    private static func normalized(_ languageCode: String?) -> String {
        let code = languageCode?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased() ?? ""
        return code.isEmpty ? "?" : String(code.prefix(3))
    }
}

import Foundation

struct KeyboardInputSource: Identifiable, Hashable, Sendable {
    let id: String
    let displayName: String
    let languageCode: String?

    init(id: String, displayName: String, languageCode: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.languageCode = languageCode
    }
}

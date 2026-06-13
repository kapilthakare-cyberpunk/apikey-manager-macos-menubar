import Foundation
import SwiftUI

class ApiKeyManager: ObservableObject {
    @Published var keys: [ApiKey] = []
    
    private let storageKey = "api_keys"
    
    init() {
        loadKeys()
    }
    
    func add(_ key: ApiKey) {
        keys.append(key)
        saveKeys()
    }
    
    func delete(_ key: ApiKey) {
        keys.removeAll { $0.id == key.id }
        saveKeys()
    }
    
    func copyToClipboard(_ key: ApiKey) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(key.key, forType: .string)
    }
    
    private func saveKeys() {
        if let data = try? JSONEncoder().encode(keys) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadKeys() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([ApiKey].self, from: data) {
            keys = decoded
        }
    }
}

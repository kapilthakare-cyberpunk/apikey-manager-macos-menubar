import Foundation

struct ApiKey: Identifiable, Codable {
    let id: UUID
    var name: String
    var provider: String
    var key: String
    var createdAt: Date
    
    init(name: String, provider: String, key: String) {
        self.id = UUID()
        self.name = name
        self.provider = provider
        self.key = key
        self.createdAt = Date()
    }
}

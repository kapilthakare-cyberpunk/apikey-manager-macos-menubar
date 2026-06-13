import SwiftUI

struct ApiKeyRow: View {
    let key: ApiKey
    let onDelete: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(key.name)
                    .font(.system(.body, weight: .medium))
                Text(key.provider)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isHovering {
                HStack(spacing: 8) {
                    Button(action: { copyToClipboard() }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.plain)
                    .help("Copy key")
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .help("Delete")
                }
            }
        }
        .padding(.vertical, 4)
        .onHover { isHovering = $0 }
    }
    
    private func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(key.key, forType: .string)
    }
}

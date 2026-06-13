import SwiftUI

struct ApiKeyRow: View {
    let key: ApiKey
    let onDelete: () -> Void
    let onCopy: () -> Void
    
    @State private var isHovering = false
    @State private var showCopied = false
    
    var providerIcon: String {
        switch key.provider.lowercased() {
        case "openai": return "brain.head.profile"
        case "anthropic": return "a.circle.fill"
        case "google": return "g.circle.fill"
        case "mistral": return "wind"
        case "cohere": return "circle.grid.cross"
        case "huggingface": return "face.smiling"
        case "github": return "chevron.left.forwardslash.chevron.right"
        default: return "key.fill"
        }
    }
    
    var providerColor: Color {
        switch key.provider.lowercased() {
        case "openai": return .green
        case "anthropic": return .orange
        case "google": return .blue
        case "mistral": return .purple
        case "cohere": return .cyan
        case "huggingface": return .yellow
        case "github": return .gray
        default: return .accentColor
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Provider Icon
            ZStack {
                Circle()
                    .fill(providerColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: providerIcon)
                    .font(.system(size: 14))
                    .foregroundColor(providerColor)
            }
            
            // Key Info
            VStack(alignment: .leading, spacing: 3) {
                Text(key.name)
                    .font(.system(.body, weight: .medium))
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text(key.provider)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(maskedKey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontDesign(.monospaced)
                }
            }
            
            Spacer()
            
            // Actions
            if isHovering {
                HStack(spacing: 4) {
                    Button(action: {
                        withAnimation {
                            showCopied = true
                        }
                        onCopy()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showCopied = false
                            }
                        }
                    }) {
                        Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 12))
                            .foregroundColor(showCopied ? .green : .secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Copy key")
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                    .help("Delete key")
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovering ? Color.accentColor.opacity(0.08) : Color.clear)
        )
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.15), value: isHovering)
    }
    
    private var maskedKey: String {
        guard key.key.count > 8 else { return "••••••••" }
        let prefix = String(key.key.prefix(4))
        let suffix = String(key.key.suffix(4))
        return "\(prefix)••••\(suffix)"
    }
}

#Preview {
    VStack {
        ApiKeyRow(
            key: ApiKey(name: "GPT-4 Production", provider: "OpenAI", key: "sk-abc123def456ghi789"),
            onDelete: {},
            onCopy: {}
        )
        ApiKeyRow(
            key: ApiKey(name: "Claude API", provider: "Anthropic", key: "sk-ant-abc123"),
            onDelete: {},
            onCopy: {}
        )
    }
    .frame(width: 340)
    .padding()
}

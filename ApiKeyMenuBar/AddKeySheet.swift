import SwiftUI

struct AddKeySheet: View {
    @ObservedObject var keyManager: ApiKeyManager
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var provider = ""
    @State private var key = ""
    @State private var showKey = false
    @State private var selectedProvider: String?
    
    let providers = [
        ("OpenAI", "brain.head.profile", .green),
        ("Anthropic", "a.circle.fill", .orange),
        ("Google AI", "g.circle.fill", .blue),
        ("Mistral AI", "wind", .purple),
        ("Cohere", "circle.grid.cross", .cyan),
        ("Hugging Face", "face.smiling", .yellow),
        ("GitHub", "chevron.left.forwardslash.chevron.right", .gray),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Add API Key")
                    .font(.headline)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Provider Selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Provider")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 80))
                        ], spacing: 8) {
                            ForEach(providers, id: \.0) { provider in
                                providerButton(provider)
                            }
                            
                            // Custom option
                            Button(action: {
                                selectedProvider = nil
                                provider = ""
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                    Text("Other")
                                        .font(.caption2)
                                }
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedProvider == nil ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        TextField("e.g., Production GPT-4", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Custom Provider Field
                    if selectedProvider == nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Provider Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            TextField("e.g., OpenAI", text: $provider)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    // Key Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("API Key")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showKey {
                                TextField("sk-...", text: $key)
                                    .textFieldStyle(.roundedBorder)
                                    .fontDesign(.monospaced)
                            } else {
                                SecureField("sk-...", text: $key)
                                    .textFieldStyle(.roundedBorder)
                                    .fontDesign(.monospaced)
                            }
                            
                            Button(action: { showKey.toggle() }) {
                                Image(systemName: showKey ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                            .help(showKey ? "Hide key" : "Show key")
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            // Footer
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("Add Key") {
                    let finalProvider = selectedProvider ?? provider
                    let newKey = ApiKey(name: name, provider: finalProvider, key: key)
                    keyManager.add(newKey)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty || key.isEmpty || (selectedProvider == nil && provider.isEmpty))
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(width: 380, height: 480)
    }
    
    func providerButton(_ provider: (String, String, Color)) -> some View {
        Button(action: {
            selectedProvider = provider.0
            self.provider = provider.0
        }) {
            VStack(spacing: 4) {
                Image(systemName: provider.1)
                    .font(.title2)
                    .foregroundColor(selectedProvider == provider.0 ? .white : provider.2)
                Text(provider.0)
                    .font(.caption2)
                    .foregroundColor(selectedProvider == provider.0 ? .white : .primary)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedProvider == provider.0 ? provider.2 : Color(nsColor: .controlBackgroundColor))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddKeySheet(keyManager: ApiKeyManager(), isPresented: .constant(true))
}

import SwiftUI

struct AddKeySheet: View {
    @ObservedObject var keyManager: ApiKeyManager
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var provider = ""
    @State private var key = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add API Key")
                .font(.headline)
            
            TextField("Name (e.g., OpenAI GPT-4)", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Provider (e.g., OpenAI)", text: $provider)
                .textFieldStyle(.roundedBorder)
            
            SecureField("API Key", text: $key)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Spacer()
                Button("Cancel") { isPresented = false }
                    .keyboardShortcut(.cancelAction)
                
                Button("Add") {
                    let newKey = ApiKey(name: name, provider: provider, key: key)
                    keyManager.add(newKey)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty || provider.isEmpty || key.isEmpty)
            }
        }
        .padding()
        .frame(width: 320)
    }
}

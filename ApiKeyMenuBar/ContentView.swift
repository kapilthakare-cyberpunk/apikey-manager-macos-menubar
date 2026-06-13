import SwiftUI

struct ContentView: View {
    @StateObject private var keyManager = ApiKeyManager()
    @State private var showingAddSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("API Key Manager")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            // Key List
            if keyManager.keys.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "key")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No API keys yet")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List {
                    ForEach(keyManager.keys) { key in
                        ApiKeyRow(key: key) { keyManager.delete(key) }
                    }
                }
                .listStyle(.plain)
            }
            
            Divider()
            
            // Footer
            HStack {
                Text("\(keyManager.keys.count) keys")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
            }
            .padding()
        }
        .frame(width: 320, height: 400)
        .sheet(isPresented: $showingAddSheet) {
            AddKeySheet(keyManager: keyManager, isPresented: $showingAddSheet)
        }
    }
}

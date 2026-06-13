import SwiftUI

struct ContentView: View {
    @StateObject private var keyManager = ApiKeyManager()
    @State private var showingAddSheet = false
    @State private var searchText = ""
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "onboarding_complete")
    
    var filteredKeys: [ApiKey] {
        if searchText.isEmpty {
            return keyManager.keys
        }
        return keyManager.keys.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.provider.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView {
                withAnimation {
                    hasCompletedOnboarding = true
                    UserDefaults.standard.set(true, forKey: "onboarding_complete")
                }
            }
        } else {
            mainView
        }
    }
    
    var mainView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView
            
            Divider()
            
            // Search Bar
            searchBar
            
            Divider()
            
            // Key List
            if keyManager.keys.isEmpty {
                emptyState
            } else if filteredKeys.isEmpty {
                noResults
            } else {
                keyList
            }
            
            Divider()
            
            // Footer
            footerView
        }
        .frame(width: 360, height: 480)
        .sheet(isPresented: $showingAddSheet) {
            AddKeySheet(keyManager: keyManager, isPresented: $showingAddSheet)
        }
    }
    
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("API Key Manager")
                    .font(.system(.title3, weight: .semibold))
                Text("\(keyManager.keys.count) key\(keyManager.keys.count == 1 ? "" : "s") stored")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showingAddSheet = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
            .help("Add new API key")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search keys...", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(Color(nsColor: .textBackgroundColor).opacity(0.5))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.fill")
                .font(.system(size: 48))
                .foregroundColor(.accentColor.opacity(0.6))
            
            VStack(spacing: 4) {
                Text("No API Keys Yet")
                    .font(.headline)
                Text("Add your first key to get started")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: { showingAddSheet = true }) {
                Label("Add API Key", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    var noResults: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundColor(.secondary)
            Text("No keys match \"\(searchText)\"")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var keyList: some View {
        ScrollView {
            LazyVStack(spacing: 2) {
                ForEach(filteredKeys) { key in
                    ApiKeyRow(key: key) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            keyManager.delete(key)
                        }
                    } onCopy: {
                        keyManager.copyToClipboard(key)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    var footerView: some View {
        HStack {
            Button(action: { NSApplication.shared.terminate(nil) }) {
                Label("Quit", systemImage: "power")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "https://github.com") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Image(systemName: "questionmark.circle")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .help("Help & Support")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

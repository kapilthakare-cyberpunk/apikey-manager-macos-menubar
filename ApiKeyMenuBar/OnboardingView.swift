import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Pages
            TabView(selection: $currentPage) {
                welcomePage.tag(0)
                featuresPage.tag(1)
                readyPage.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            // Bottom Controls
            HStack {
                if currentPage > 0 {
                    Button("Back") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Page Indicators
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                
                Spacer()
                
                Button(currentPage == 2 ? "Get Started" : "Next") {
                    withAnimation {
                        if currentPage < 2 {
                            currentPage += 1
                        } else {
                            onComplete()
                        }
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                .fontWeight(.semibold)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .frame(width: 400, height: 400)
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "key.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.accentColor, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("Welcome to")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text("API Key Manager")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Text("Securely store and manage all your\nAPI keys in one place.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
    
    var featuresPage: some View {
        VStack(spacing: 20) {
            Spacer()
            
            featureRow(icon: "lock.shield.fill", title: "Secure Storage", color: .green)
            featureRow(icon: "doc.on.doc.fill", title: "One-Click Copy", color: .blue)
            featureRow(icon: "magnifyingglass", title: "Quick Search", color: .orange)
            featureRow(icon: "cloud.fill", title: "iCloud Sync", color: .purple)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    func featureRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    var readyPage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text("You're All Set!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Click below to add your first API key.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}

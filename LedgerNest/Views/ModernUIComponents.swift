//
//  ModernUIComponents.swift
//  LedgerNest
//
//  Modern UI components and design system
//

import SwiftUI

// MARK: - Color Scheme
extension Color {
    static let appPrimary = Color(red: 0.2, green: 0.4, blue: 0.9)
    static let appSecondary = Color(red: 0.3, green: 0.5, blue: 1.0)
    static let appAccent = Color(red: 0.1, green: 0.7, blue: 0.9)
    static let cardBackground = Color(.systemBackground)
    static let cardShadow = Color.black.opacity(0.1)
}

// MARK: - Modern Button Style
struct ModernButtonStyle: ButtonStyle {
    var isPrimary: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(isPrimary ? .white : .appPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isPrimary {
                        LinearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color(.systemBackground)
                    }
                }
            )
            .cornerRadius(16)
            .shadow(color: isPrimary ? .appPrimary.opacity(0.3) : .clear, radius: configuration.isPressed ? 4 : 8, x: 0, y: configuration.isPressed ? 2 : 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Modern Card Style
struct ModernCard: ViewModifier {
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardBackground)
            .cornerRadius(20)
            .shadow(color: Color.cardShadow, radius: 10, x: 0, y: 4)
            .shadow(color: Color.cardShadow.opacity(0.5), radius: 1, x: 0, y: 1)
    }
}

extension View {
    func modernCard(padding: CGFloat = 16) -> some View {
        modifier(ModernCard(padding: padding))
    }
}

// MARK: - Icon Container
struct IconContainer: View {
    let iconName: String
    let size: CGFloat
    let color: Color
    
    init(iconName: String, size: CGFloat = 60, color: Color = .appPrimary) {
        self.iconName = iconName
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size * 0.5))
            .foregroundColor(color)
            .frame(width: size, height: size)
            .background(
                LinearGradient(
                    colors: [color.opacity(0.2), color.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(size * 0.3)
            .overlay(
                RoundedRectangle(cornerRadius: size * 0.3)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Animated Loading View
struct ModernLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.appPrimary)
                
                Text("Processing...")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .shadow(radius: 20)
        }
    }
}

// MARK: - Section Header
struct ModernSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
    }
}

// MARK: - Empty State View
struct ModernEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            IconContainer(iconName: icon, size: 100, color: .appPrimary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: action) {
                Label(actionTitle, systemImage: "plus.circle.fill")
            }
            .buttonStyle(ModernButtonStyle())
            .padding(.horizontal, 40)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


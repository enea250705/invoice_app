//
//  OnboardingView.swift
//  LedgerNest
//
//  First launch onboarding screen
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateIcon = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Animated icon
                IconContainer(iconName: "building.2.fill", size: 120, color: .appPrimary)
                    .scaleEffect(animateIcon ? 1.05 : 1.0)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true)
                        ) {
                            animateIcon = true
                        }
                    }
                
                VStack(spacing: 16) {
                    Text("LedgerNest")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.appPrimary, .appSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Organize invoices for all your properties in one place.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                        .lineSpacing(4)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text("Get Started")
                }
                .buttonStyle(ModernButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}


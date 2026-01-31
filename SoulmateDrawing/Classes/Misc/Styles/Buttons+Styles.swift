//
//  Buttons+Styles.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var isLoading = false
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        environment(\.isLoading, isLoading)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isLoading) private var isLoading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.accentMain100
            if isLoading {
                SpinnerView()
            } else {
                configuration.label
                    .foregroundStyle(.textMain100)
                    .font(Font.SFPro.font(size: 17, weight: .w510))
            }
        }
        .frame(height: 56)
        .clipShape(Capsule())
        .opacity(isEnabled ? 1 : 0.4)
        .disabled(isLoading)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.bgMain300
            configuration.label
                .foregroundStyle(.textMain200)
                .font(Font.SFPro.font(size: 17, weight: .w510))
        }
        .frame(height: 56)
        .clipShape(Capsule())
        .opacity(isEnabled ? 1 : 0.4)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: Self { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: Self { SecondaryButtonStyle() }
}

struct BackgroundImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
    }
}

struct ProButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Image("bgpro")
                    .resizable()
            }
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.interpolatingSpring(), value: configuration.isPressed)
    }
}

struct ProButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Image("prostar")
                Text("PRO")
                    .font(Font.Gambarino.font(size: 16, weight: .w400))
                    .foregroundStyle(.textMain100)
            }
            .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 12))
        }
        .buttonStyle(.pro)
    }
}

extension ButtonStyle where Self == ProButtonStyle {
    static var pro: Self { ProButtonStyle() }
}

extension View {
    func appBackground() -> some View {
        modifier(BackgroundImageModifier())
    }
}

#Preview {
    VStack {
        Button(action: {}) {
            Text("Main")
        }
        .buttonStyle(.primary)
        
        Button(action: {}) {
            Text("Main")
        }
        .buttonStyle(.primary)
        .loading(true)
        
        Button(action: {}) {
            HStack(spacing: 0) {
                Image("prostar")
                Text("PRO")
                    .font(Font.Gambarino.font(size: 16, weight: .w400))
                    .foregroundStyle(.textMain100)
            }
            .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 12))
        }
        .buttonStyle(.pro)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .appBackground()
}

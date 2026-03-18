//
//  ErrorScreenView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 09.10.2024.
//

import SwiftUI

enum ErrorScreenType: Identifiable {
    case internet
    case request
    case appstore
    
    var id: Self { self }
}

extension View {
    func screenState(
        _ state: ScreenState,
        bottomOffset: CGFloat = .zero
    ) -> some View {
        modifier(ScreenStateModifier(state: state, bottomOffset: bottomOffset))
    }
}

enum ScreenState {
    case loading
    case loaded
    case error(() -> Void)
}

struct ScreenStateModifier: ViewModifier {
    let state: ScreenState
    let bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        switch state {
        case .loading:
            ZStack {
                Color.clear
                ProgressView()
                    .progressViewStyle(.spinner)
            }
            .appBackground()
        case .loaded:
            content
        case .error(let tryAgain):
            ErrorScreenView(errorType: .request, tryAgain: tryAgain)
                .padding(.bottom, bottomOffset)
        }
    }
}

private struct ErrorScreenView: View {
    private let errorType: ErrorScreenType
    private let tryAgain: () -> Void
    
    init(errorType: ErrorScreenType, tryAgain: @escaping () -> Void) {
        self.errorType = errorType
        self.tryAgain = tryAgain
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(errorType.imageName)
                .padding(.bottom, 20.scale)
            Text(errorType.title)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.bottom, 12.scale)
            Text(errorType.subtitle)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .lineSpacing(3)
            Spacer()
            
            Button(
                action: tryAgain,
                label: { Text("Error.TryAgain".localized) }
            )
            .buttonStyle(.primary)
            
            if errorType == .request {
                Link(destination: GlobalDefinitions.support) {
                    Text("Error.Support".localized)
                }
                .buttonStyle(.secondary)
                .padding(.top, 16.scale)
            }
        }
        .padding(.horizontal, 22.scale)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background {
            Color.bgMain100.ignoresSafeArea()
        }
    }
}

#Preview {
    ErrorScreenView(errorType: .request) {}
}

private extension ErrorScreenType {
    var imageName: String {
        switch self {
        case .internet:
            "Error.Internet"
        case .request:
            "Error.Request"
        case .appstore:
            "Error.Appstore"
        }
    }
    
    var title: String {
        switch self {
        case .internet:
            "Error.Internet.Title".localized
        case .request:
            "Error.Request.Title".localized
        case .appstore:
            "Error.Appstore.Title".localized
        }
    }
    
    var subtitle: String {
        switch self {
        case .internet:
            "Error.Internet.Subtitle".localized
        case .request:
            "Error.Request.Subtitle".localized
        case .appstore:
            "Error.Appstore.Subtitle".localized
        }
    }
}

extension ScreenState: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.loaded, .loaded):
            return true
        default:
            return false
        }
    }
}

//
//  UINavigationController+Extensions.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.01.2026.
//

import UIKit
import SwiftUI

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarButton(placement: .topBarLeading) {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.navigation)
                }
            }
    }
}

struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 24, height: 24)
            .padding(8)
            .background(.bgMain300)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.interpolatingSpring(), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == NavigationButtonStyle {
    static var navigation: Self { .init() }
}

extension View {
    func customBackButton() -> some View {
        modifier(CustomBackButtonModifier())
    }
}

struct ToolbarButton<Content>: ToolbarContent where Content: View {
    let placement: ToolbarItemPlacement
    @ViewBuilder var content: () -> Content
    
    var body: some ToolbarContent {
        if #available(iOS 26, *) {
            ToolbarItem(placement: placement, content: content)
//                .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: placement, content: content)
        }
    }
}

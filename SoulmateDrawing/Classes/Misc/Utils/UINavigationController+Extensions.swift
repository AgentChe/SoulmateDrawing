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

extension View {
    func customBackButton() -> some View {
        modifier(CustomBackButtonModifier())
    }
}

extension View {
    func closeButton(action: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: action,
                    label: { Image(systemName: "xmark") }
                )
                .foregroundStyle(.textMain200)
                .buttonStyle(.navigation)
            }
        }
    }
}

struct ToolbarButton<Content>: ToolbarContent where Content: View {
    let placement: ToolbarItemPlacement
    @ViewBuilder var content: () -> Content
    
    var body: some ToolbarContent {
        if #available(iOS 26, *) {
            ToolbarItem(placement: placement, content: content)
                .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: placement, content: content)
        }
    }
}

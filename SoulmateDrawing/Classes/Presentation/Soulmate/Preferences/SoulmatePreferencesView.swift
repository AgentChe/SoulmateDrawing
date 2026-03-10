//
//  SoulmatePreferencesView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.02.2026.
//

import SwiftUI

struct SoulmatePreferencesView: View {
    let elements: [String]
    let selected: (String) -> Void
    
    @State private var current: String?
    
    init(elements: [String], selected: @escaping (String) -> Void) {
        self.elements = elements
        self.selected = selected
        self._current = State(initialValue: elements.first)
    }
    
    var body: some View {
        VStack {
            Text("Soulmate.Preferences.Region".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 60.scale)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12.scale) {
                    ForEach(elements, id: \.self) { item in
                        Button(
                            action: {
                                withAnimation {
                                    current = item
                                }
                            },
                            label: {
                                Text(item)
                                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                                    .foregroundStyle(.textMain200)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16.scale)
                                    .background {
                                        let color = item == current
                                        ? Color(red: 144/255, green: 115/255, blue: 95/255, opacity: 0.4)
                                        : Color.bgMain300
                                        
                                        color
                                            .foregroundStyle(
                                                .shadow(.drop(color: Color.white.opacity(0.04), radius: 1, x: 1, y: 1))
                                                .shadow(.drop(color: Color.white.opacity(0.06), radius: 1, x: -1, y: -1))
                                            )
                                            .shadow(radius: 20)
                                    }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16.scale))
                        .buttonStyle(.card)
                    }
                }
            }
            .padding(.horizontal, 24.scale)
        }
        .safeAreaInset(edge: .bottom) {
            Button(
                action: {
                    if let current {
                        selected(current)
                    }
                },
                label: {
                    Text("Next".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            .disabled(current == nil)
        }
        .frame(maxWidth: .infinity)
        .appBackground()
    }
}

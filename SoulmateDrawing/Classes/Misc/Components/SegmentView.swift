//
//  SegmentView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct SegmentItemKey<I: Hashable>: PreferenceKey {
    typealias Value = [I: Anchor<CGRect>]
    static var defaultValue: Value { [:] }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

struct SegmentView<Element: Hashable, Content: View>: View {
    let elements: [Element]
    @Binding var selection: Element
    @ViewBuilder var content: (Element) -> Content
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(elements, id: \.self) { value in
                content(value)
                    .padding(.horizontal, 12)
                    .anchorPreference(key: SegmentItemKey.self, value: .bounds) { [value: $0] }
                    .onTapGesture {
                        withAnimation {
                            selection = value
                        }
                    }
            }
        }
        .padding(4)
        .frame(height: 40)
        .background {
            Color.bgMain300
                .blur(radius: 2)
        }
        .clipShape(Capsule())
        .backgroundPreferenceValue(SegmentItemKey.self) { preferences in
            if let anchor = preferences[selection] {
                GeometryReader { geometry in
                    let rect = geometry[anchor]
                    Capsule()
//                        .fill(Color.bgMain200)
                        .foregroundStyle(
                            Color
                                .bgMain200
                                .shadow(.inner(color: Color.white.opacity(0.04), radius: 1, x: 1, y: 1))
                                .shadow(.inner(color: Color.white.opacity(0.06), radius: 1, x: -1, y: -1))
                        )
                        .padding(.vertical, 4)
                        .frame(width: rect.width)
//                        .shadow(color: Color.red.opacity(0.94), radius: 1, x: 1, y: 1)
                        
                        .position(x: rect.midX, y: rect.midY)
                }
            }
        }
    }
}


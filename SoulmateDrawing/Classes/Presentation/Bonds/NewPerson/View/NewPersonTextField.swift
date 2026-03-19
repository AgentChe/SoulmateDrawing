//
//  NewPersonTextField.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import SwiftUI

extension VerticalAlignment {
    struct InputGuide: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    
    static let inputGuide = VerticalAlignment(InputGuide.self)
}

struct NewPersonTextField: View {
    let placeholder: String
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    
    @State var paddingContent: EdgeInsets = .init(top: 16.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale)
    
    @State private var isAvailableContent = false
    
    var body: some View {
        TextField("", text: $text)
            .alignmentGuide(.inputGuide) {
                $0[isAvailableContent ? .top : VerticalAlignment.center]
            }
            .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            .tint(.textMain200)
            .foregroundStyle(.textMain200)
            .focused(isFocused)
            .padding(paddingContent)
            .background(.bgMain300, in: RoundedRectangle(cornerRadius: 16.scale))
            .overlay(alignment: .init(horizontal: .leading, vertical: .inputGuide)) {
                Text(placeholder)
                    .font(Font.SFPro.font(size: isAvailableContent ? 14.scale : 17.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .opacity(0.3)
                    .padding(.horizontal, 16.scale)
                    .alignmentGuide(.inputGuide) {
                        $0[isAvailableContent ? .bottom : VerticalAlignment.center]
                    }
            }
            .onChange(of: text.isEmpty) { oldValue, newValue in
                guard oldValue != newValue else { return }
                withAnimation {
                    isAvailableContent = newValue || isFocused.wrappedValue
                }
            }
            .onChange(of: isFocused.wrappedValue) { oldValue, newValue in
                guard oldValue != newValue else { return }
                withAnimation {
                    isAvailableContent = newValue || !text.isEmpty
                }
            }
            .onChange(of: isAvailableContent) { oldValue, newValue in
                guard newValue != oldValue else { return }
                withAnimation {
                    paddingContent = .init(
                        top: newValue ? 26.scale : 16.scale,
                        leading: 16.scale,
                        bottom: newValue ? 9.scale : 16.scale,
                        trailing: 16.scale
                    )
                }
            }
    }
}

//
//  ConnectionTypeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct ConnectionTypeView: View {
    let selected: (ConnectionType) -> Void
    
    private let types: [ConnectionType] = ConnectionType.allCases
    @State private var height: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 4.scale) {
            ForEach(types, id: \.self) { type in
                Button(
                    action: { selected(type) },
                    label: {
                        Text(type.title)
                            .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                            .foregroundStyle(.textMain200)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 9.5, leading: 24.scale, bottom: 13.5.scale, trailing: 24.scale))
                    }
                )
            }
        }
        .padding(.top, 32.scale)
        .onGeometryChange(
            for: CGFloat.self,
            of: { $0.size.height },
            action: { height = $0 }
        )
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
//        .presentationCornerRadius(32.scale)
        .background {
            Color.bgMain200.ignoresSafeArea()
        }
    }
}

#Preview {
    ConnectionTypeView { _ in }
}

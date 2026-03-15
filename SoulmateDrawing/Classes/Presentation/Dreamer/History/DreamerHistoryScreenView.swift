//
//  DreamerHistoryScreenView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import SwiftUI

struct DreamerHistoryScreenView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = DreamHistoryViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.scale) {
                ForEach(viewModel.items) { item in
                    Button(
                        action: { navigation.push(.dreamerDetails(type: .load(id: item.id))) },
                        label: { DreamerHistoryItemView(item: item) }
                    )
                    .buttonStyle(.card)
                    .itemShadow()
                    .onAppear {
                        if viewModel.items.last?.id == item.id {
                            viewModel.loadNext()
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 24.scale)
        .appBackground()
        .screenState(viewModel.screenState, tryAgain: viewModel.load)
        .customBackButton()
    }
}

#Preview {
    NavigationStack {
        DreamerHistoryScreenView()
    }
}

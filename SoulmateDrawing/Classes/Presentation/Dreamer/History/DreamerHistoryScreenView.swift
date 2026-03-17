//
//  DreamerHistoryScreenView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import SwiftUI

struct DreamerHistoryScreenView: View {
    @State var viewModel: DreamHistoryViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.scale) {
                ForEach(viewModel.items) { item in
                    Button(
                        action: { viewModel.showDetails(for: item.id) },
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
        .bluredNavigationBar()
        .contentMargins([.horizontal, .top], 24.scale)
        .appBackground()
        .screenState(viewModel.screenState)
        .customBackButton()
    }
}

//
//  InsightsListView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct InsightsListView: View {
    @State var viewModel: InsightsListViewModel
    
    var body: some View {
        List {
            Section(
                content: {
                    ForEach(viewModel.items) { model in
                        Button(
                            action: {
                                viewModel.openChat(for: model)
                            },
                            label: {
                                BondsInsightCard(model: model)
                            }
                        )
                        .buttonStyle(.card)
                        .onAppear {
                            if viewModel.items.last == model {
                                viewModel.loadNext()
                            }
                        }
                    }
                },
                footer: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .progressViewStyle(.spinner)
                    }
                }
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(.init())
        }
        .bluredNavigationBar()
        .listRowSpacing(16.scale)
        .scrollContentBackground(.hidden)
        .contentMargins(24.scale, for: .scrollContent)
        .appBackground()
        .screenState(viewModel.screenState)
        .customBackButton()
        .listStyle(.plain)
    }
}

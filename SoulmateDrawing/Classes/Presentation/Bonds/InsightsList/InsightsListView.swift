//
//  InsightsListView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct InsightsListView: View {
//    @Environment(\.navigation) private var router
    @State var viewModel: InsightsListViewModel
    
    var body: some View {
        List {
            Section(
                content: {
                    ForEach(viewModel.items) { model in
                        Button(
                            action: {
                                viewModel.openChat(for: model)
        //                            router.push(.chat(.open(threadID: model.id)))
                            },
                            label: {
                                BondsInsightCard(model: model)
                            }
                        )
                        .buttonStyle(.card)
                        .onAppear {
                            viewModel.loadNext()
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
        .listRowSpacing(16)
        .scrollContentBackground(.hidden)
        .contentMargins(24.scale, for: .scrollContent)
        .appBackground()
        .screenState(viewModel.screenState)
        .customBackButton()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: {},
                    label: {
                        Image(systemName: "ellipsis")
                    }
                )
                .buttonStyle(.navigation)
            }
        }
        .customTabBarVisible(false)
        .listStyle(.plain)
    }
}

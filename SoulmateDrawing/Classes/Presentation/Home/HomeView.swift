//
//  HomeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct HomeView: View {
//    @Environment(\.navigation) private var navigation
    @State var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ProfileView(
                        name: viewModel.profileName,
                        sign: viewModel.sign,
                        mainPoints: viewModel.mainPoints
                    )
                    
                    SegmentView(
                        elements: HomeSegmentItem.allCases,
                        selection: $viewModel.selectionSegment
                    ) { value in
                        Text(value.name)
                            .font(Font.SFPro.font(size: 16.scale, weight: .w510))
                            .foregroundStyle(.textMain200)
                    }
                    .padding(.top, 24.scale)
                    
                    switch viewModel.selectionSegment {
                    case .explore:
                        HomeExploreView(selected: viewModel.selectedExplore)
                            .padding(.top, 16.scale)
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                            .clipped()
                    case .chart:
                        ChartsView(charts: viewModel.charts)
                            .padding(.horizontal, 24.scale)
                            .padding(.top, 32.scale)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            }
            .padding(.top, -20.scale)
            .screenState(viewModel.screenState)
        }
        .toolbar {
            ToolbarButton(placement: .topBarLeading) {
                Button(
                    action: {
                        viewModel.showSettings()
                    },
                    label: { Image("settings") }
                )
                .buttonStyle(.navigation)
            }
            if !viewModel.hasActiveSubscription {
                ToolbarButton(placement: .topBarTrailing) {
                    ProButton {
                        viewModel.showPaygate()
                    }
                }
            }
        }
        .bluredNavigationBar()
        .appBackground()
    }
}

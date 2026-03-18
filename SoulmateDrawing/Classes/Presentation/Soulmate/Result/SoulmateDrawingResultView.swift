//
//  SoulmateDrawingResultView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI
import NukeUI

struct SoulmateDrawingResultView: View {
    @Environment(\.displayScale) var displayScale
    @State var viewModel: SoulmateDrawingResultViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Text("Soulmate.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16.scale)
                    .padding(.top, 24.scale)
                
                MainPointsView(mainPoints: viewModel.mainPoints)
                    .padding(.top, 12.scale)
                
                RoundedRectangle(cornerRadius: 32.scale)
                    .fill(Color(red: 1, green: 251/255, blue: 435/255))
                    .aspectRatio(0.98, contentMode: .fit)
                    .overlay {
                        LazyImage(source: viewModel.imageURL) { state in
                            if let image = state.image {
                                image
                            } else {
                                Color.clear
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32.scale))
                    .padding(.vertical, 24.scale)
                
                SegmentView(
                    elements: SoulmateSegmentItem.allCases,
                    selection: $viewModel.selectedSegment
                ) { value in
                    Text(value.name)
                        .font(Font.SFPro.font(size: 16.scale, weight: .w510))
                        .foregroundStyle(.textMain200)
                }
                .padding(.bottom, 16.scale)
                
                switch viewModel.selectedSegment {
                case .explore:
                    SoulmateExploreView(
                        title: viewModel.exploreTitle,
                        items: viewModel.exploreItems,
                        hasActiveSubscription: viewModel.hasActiveSubscription,
                        selected: {
                            if !$0.isLocked || viewModel.hasActiveSubscription {
                                viewModel.openDetails(item: $0)
                            }
                        },
                        unfoldAction: {
                            viewModel.showPaygate()
                        }
                    )
                case .chart:
                    ChartsView(charts: viewModel.charts)
                }
            }
            .padding(.horizontal, 24.scale)
        }
        .animation(.default, value: viewModel.selectedSegment)
        .safeAreaInset(edge: .bottom) {
            Button(
                action: viewModel.startOver,
                label: {
                    Text("Soulmate.Start".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
        }
        .bluredNavigationBar()
        .appBackground()
        .customBackButton()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.spinner)
                } else {
                    Button(
                        action: {
                            viewModel.testShare(scale: displayScale)
                        },
                        label: { Image("share") }
                    )
                    .buttonStyle(.navigation)
                }
            }
        }
        .onAppear(perform: viewModel.checkActiveSubscription)
    }
}

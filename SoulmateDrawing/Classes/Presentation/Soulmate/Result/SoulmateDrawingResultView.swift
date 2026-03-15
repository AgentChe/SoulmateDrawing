//
//  SoulmateDrawingResultView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI
import NukeUI

struct SoulmateDrawingResultView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel: SoulmateDrawingResultViewModel
    @State private var isShowPaygate = false
    
    init(soulmate: SoulmateModel) {
        _viewModel = State(initialValue: .init(soulmate: soulmate))
    }
    
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
                                navigation.push(.exploreDetails($0))
                            }
                        },
                        unfoldAction: {
                            isShowPaygate = true
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
                action: {
                    navigation.fullScreen(.soulmateCheckProfile)
                    navigation.pop()
                },
                label: {
                    Text("Soulmate.Start".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
        }
        .appBackground()
        .fullScreenCover(isPresented: $isShowPaygate) {
            NavigationStack {
                PaygateView()
            }
        }
    }
}

struct SoulmateExploreView: View {
    let title: String
    let items: [ExploreItem]
    let hasActiveSubscription: Bool
    let selected: (ExploreItem) -> Void
    let unfoldAction: () -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200)
            
            Text("Soulmate.Explore.Title".localized)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 32.scale)
            
            ForEach(items, id: \.self) { item in
                Button(
                    action: { selected(item) },
                    label: {
                        SoulmateExploreCardView(item: item, hasActiveSubscription: hasActiveSubscription, unfoldAction: unfoldAction)
                    }
                )
                .buttonStyle(.card)
                .itemShadow()
            }
            .padding(.top, 16.scale)
        }
        .customBackButton()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: { },
                    label: { Image("share") }
                )
                .buttonStyle(.navigation)
            }
        }
        .customTabBarVisible(false)
    }
}

//
//  SoulmateDrawingResultView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI

enum SoulmateSegmentItem: Hashable, CaseIterable {
    case explore
    case chart
    
    var name: String {
        switch self {
        case .explore:
            "Soulmate.Segment.Explore".localized
        case .chart:
            "Soulmate.Segment.Chart".localized
        }
    }
}

struct SoulmateDrawingResultView: View {
    @State private var viewModel = SoulmateDrawingResultViewModel()
    @State private var selectedSegment: SoulmateSegmentItem = .explore
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Text("Soulmate.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                
                MainPointsView(mainPoints: viewModel.mainPoints)
                    .padding(.top, 12)
                
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color(red: 1, green: 251/255, blue: 435/255))
                    .aspectRatio(0.98, contentMode: .fit)
                    .overlay {
                        AsyncImage(
                            url: viewModel.imageURL,
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            },
                            placeholder: {
                                
                            }
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .padding(.vertical, 24)
                
                SegmentView(
                    elements: SoulmateSegmentItem.allCases,
                    selection: $selectedSegment
                ) { value in
                    Text(value.name)
                        .font(Font.SFPro.font(size: 16, weight: .w510))
                        .foregroundStyle(.textMain200)
                }
                .padding(.bottom, 16)
                
                switch selectedSegment {
                case .explore:
                    SoulmateExploreView(
                        title: viewModel.exploreTitle,
                        items: viewModel.exploreItems
                    )
                case .chart:
                    ChartsView(charts: viewModel.charts)
                }
            }
            .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .bottom) {
            Button(
                action: {},
                label: {
                    Text("Soulmate.Start".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .appBackground()
    }
}

struct SoulmateExploreView: View {
    let title: String
    let items: [ExploreItem]
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.SFPro.font(size: 17, weight: .w400))
                .foregroundStyle(.textMain200)
            
            Text("Soulmate.Explore.Title".localized)
                .font(Font.Gambarino.font(size: 22, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 32)
            
            ForEach(items, id: \.self) { item in
                Button(
                    action: {},
                    label: {
                        SoulmateExploreCardView(item: item) {
                            
                        }
                    }
                )
                .buttonStyle(.card)
            }
            .padding(.top, 16)
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
    }
}

#Preview {
    NavigationStack {
        SoulmateDrawingResultView()
    }
}

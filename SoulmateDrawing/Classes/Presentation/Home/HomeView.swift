//
//  HomeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selection: HomeSegmentItem = .explore
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ProfileView(
                    name: "Magan",
                    zodiac: .aries,
                    mainPoints: viewModel.mainPoints
                )
                
                SegmentView(
                    elements: HomeSegmentItem.allCases,
                    selection: $selection
                ) { value in
                    Text(value.name)
                        .font(Font.SFPro.font(size: 16, weight: .w510))
                        .foregroundStyle(.textMain200)
                }
                .padding(.top, 24)
                
                switch selection {
                case .explore:
                    HomeExploreView()
                        .padding(.top, 16)
                case .chart:
                    HomeChartView(charts: viewModel.charts)
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                }
            }
        }
//        .scrollContentBackground(.hidden)
//        .navigationBarHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            if #available(iOS 26, *) {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {},
                        label: {
                            Image("settings")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ProButton {}
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {},
                        label: {
                            Image("settings")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(8)
                                .background(.bgMain300)
                                .clipShape(Circle())
                        }
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ProButton {
                        
                    }
                }
            }
        }
        .appBackground()
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

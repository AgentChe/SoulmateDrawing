//
//  HomeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct HomeView: View {
//    @Environment(Coordinator<HomeRoute>.self) private var coordinator
    @State private var viewModel = HomeViewModel()
    @State private var selection: HomeSegmentItem = .explore
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ProfileView(
                    name: viewModel.profileName,
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
                    HomeExploreView { selected in
                        
                    }
                    .padding(.top, 16)
                case .chart:
                    ChartsView(charts: viewModel.charts)
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                }
            }
        }
//        .scrollContentBackground(.hidden)
//        .navigationBarHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarButton(placement: .topBarLeading) {
                Button(
                    action: {
//                            coordinator.sheet(.settings)
                    },
                    label: { Image("settings") }
                )
                .buttonStyle(.navigation)
            }
            
            ToolbarButton(placement: .topBarTrailing) {
                ProButton {}
            }
        }
        .appBackground()
        .screenState(viewModel.screenState) {
            viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

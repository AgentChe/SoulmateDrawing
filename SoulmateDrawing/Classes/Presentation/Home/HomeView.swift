//
//  HomeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = HomeViewModel()
    
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
                    selection: $viewModel.selectionSegment
                ) { value in
                    Text(value.name)
                        .font(Font.SFPro.font(size: 16, weight: .w510))
                        .foregroundStyle(.textMain200)
                }
                .padding(.top, 24)
                
                switch viewModel.selectionSegment {
                case .explore:
                    HomeExploreView(selected: viewModel.selectedExplore)
                        .padding(.top, 16)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .chart:
                    ChartsView(charts: viewModel.charts)
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
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
                        viewModel.showSettings()
//                            coordinator.sheet(.settings)
                    },
                    label: { Image("settings") }
                )
                .buttonStyle(.navigation)
            }
            if #available(iOS 26, *) {
                ToolbarButton(placement: .topBarTrailing) {
                    ProButton {
                        viewModel.showPaygate()
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarButton(placement: .topBarTrailing) {
                    ProButton {
                        viewModel.showPaygate()
                    }
                }
            }
        }
        .appBackground()
        .screenState(viewModel.screenState) {
            viewModel.load()
        }
        .onChange(of: viewModel.fullScreen) { oldValue, newValue in
            guard let newValue else { return }
            switch newValue {
            case .settings:
                navigation.fullScreen(.settings)
            case .paygate:
                navigation.fullScreen(.paygate)
            case .soulmateOnboarding:
                navigation.fullScreen(.soulmateOnboarding)
            case .soulmateCheckProfile:
                navigation.fullScreen(.soulmateCheckProfile)
            }
            viewModel.fullScreen = nil
        }
        .onChange(of: viewModel.push) { _, newValue in
            if let newValue {
                navigation.push(newValue)
                viewModel.push = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

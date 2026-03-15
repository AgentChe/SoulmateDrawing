//
//  HomeView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import SwiftUI

struct HeaderBlur: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
        } else {
            content
                .mask {
                    Color.black
                        .overlay(alignment: .top) {
                            LinearGradient(colors: [.black.opacity(0.75), .black.opacity(0.25), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                        }
                        .blur(radius: 20)
                }
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

extension View {
    func bluredNavigationBar() -> some View {
        modifier(HeaderBlur())
    }
}

struct HomeView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = HomeViewModel()
    
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
            .screenState(viewModel.screenState) {
                viewModel.load()
            }
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .appBackground()
        .fullScreenCover(item: $viewModel.fullScreen) { item in
            NavigationStack {
                switch item {
                case .settings:
                    SettingsView()
                case .paygate:
                    PaygateView()
                case .soulmateOnboarding:
                    SoulmateOnboarding()
                case .soulmateCheckProfile:
                    SoulmateCheckProfile()
                }
            }
        }
        .onChange(of: viewModel.push) { _, newValue in
            if let newValue {
                navigation.push(newValue)
                viewModel.push = nil
            }
        }
        .onChange(of: viewModel.switchTab) { _, newValue in
            if let newValue {
                navigation.selectTab(newValue)
            }
        }
        .task {
            viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

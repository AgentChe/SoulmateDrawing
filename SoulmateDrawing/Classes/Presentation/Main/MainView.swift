//
//  MainView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.12.2025.
//

import SwiftUI

enum TabElement: Hashable, CaseIterable, Identifiable {
    case home
    case dreamer
    case bonds
    
    var id: Self { self }
    
    var iconName: String {
        switch self {
        case .home:
            "home"
        case .dreamer:
            "dreamer"
        case .bonds:
            "bonds"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            "Home".localized
        case .dreamer:
            "Dreamer".localized
        case .bonds:
            "Bonds"
            .localized
        }
    }
    
    @ViewBuilder
    var rootView: some View {
        switch self {
        case .home:
            HomeView()
        case .dreamer:
            Color.red
        case .bonds:
            BondsView()
        }
    }
}

struct MainView: View {
    @State var selected: TabElement = .home
    @Environment(\.navigation) private var navigation
    var body: some View {
        RootNavigationStack {
            TabBarView(items: TabElement.allCases, selected: $selected) { tab in }
        }
    }
}

#Preview {
    MainView()
}

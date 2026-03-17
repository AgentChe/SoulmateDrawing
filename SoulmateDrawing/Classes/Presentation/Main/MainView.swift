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
            "Bonds".localized
        }
    }
}

struct CustomTabBarVisiblePreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value && nextValue()
    }
}

extension View {
    func customTabBarVisible(_ visible: Bool) -> some View {
        preference(key: CustomTabBarVisiblePreferenceKey.self, value: visible)
    }
}

struct MainView: View {
    @State private var router = NavigationManager.shared
    @State var isVisible = true
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
//            ForEach(TabElement.allCases) { tab in
//                RootNavigationStack(router: router) {
//                    switch tab {
//                    case .home:
//                        HomeView()
//                    case .dreamer:
//                        DreamerMainScreen()
//                    case .bonds:
//                        BondsView()
//                    }
//                }
//                .toolbar(.hidden, for: .tabBar)
//                .onPreferenceChange(CustomTabBarVisiblePreferenceKey.self) { value in
//                    withAnimation {
//                        isVisible = value
//                    }
//                }
//            }
        }
        .overlay(alignment: .bottom) {
            if isVisible {
                TabBarView(selected: router.selectedTab) {
                    router.selectTab($0)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        // TODO: Перепроверить корректность отображения
//        .ignoresSafeArea(.keyboard)
    }
}

struct TabBarView: View {
    var selected: TabElement
    let action: (TabElement) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabElement.allCases) { item in
                Button(
                    action: {
                        withAnimation {
                            action(item)
                        }
                    },
                    label: {
                        VStack(spacing: 2) {
                            Image(item.iconName)
                                .resizable()
                                .frame(width: 24.scale, height: 24.scale)
                            Text(item.title)
                        }
                        .foregroundStyle(selected == item ? .textMain200 : .textMain200.opacity(0.4))
                    }
                )
                .frame(width: 60.scale, height: 75.scale)
                if item != TabElement.allCases.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 40.scale)
        .font(Font.SFPro.font(size: 12.scale, weight: .w510))
        .background(.bgMain100)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(red: 144/255, green: 115/255, blue: 95/255, opacity: 0.1))
                .frame(height: 1)
        }
    }
}

#Preview {
    MainView()
}

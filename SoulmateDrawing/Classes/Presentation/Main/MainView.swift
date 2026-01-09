//
//  MainView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.12.2025.
//

import SwiftUI

enum TabElement: Hashable, CaseIterable {
    case home
    case dreamer
    case bounds
}

struct MainView: View {
    @State var selected: TabElement = .home
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch selected {
                case .home:
                    HomeView()
                case .dreamer:
                    Color.red
                case .bounds:
                    Color.blue
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button(
                        action: { select(.home) },
                        label: {
                            VStack(spacing: 2) {
                                Image("home")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Home")
                            }
                            .foregroundStyle(selected == .home ? .textMain200 : .textMain200.opacity(0.4))
                        }
                    )
                    .frame(width: 75, height: 60)
                    
                    Spacer()
                    Button(
                        action: { select(.dreamer) },
                        label: {
                            VStack(spacing: 2) {
                                Image("dreamer")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Dreamer")
                            }
                            .foregroundStyle(selected == .dreamer ? .textMain200 : .textMain200.opacity(0.4))
                        }
                    )
                    .frame(width: 75, height: 60)
                    
                    Spacer()
                    
                    Button(
                        action: { select(.bounds) },
                        label: {
                            VStack(spacing: 2) {
                                Image("bounds")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Bounds")
                            }
                            .foregroundStyle(selected == .bounds ? .textMain200 : .textMain200.opacity(0.4))
                        }
                    )
                    .frame(width: 75, height: 60)
                    Spacer()
                }
                .font(Font.SFPro.font(size: 12, weight: .w510))
                .background(.bgMain100)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color(red: 144/255, green: 115/255, blue: 95/255, opacity: 0.1))
                        .frame(height: 1)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func select(_ tab: TabElement) {
        withAnimation {
            selected = tab
        }
    }
}

#Preview {
    MainView()
}

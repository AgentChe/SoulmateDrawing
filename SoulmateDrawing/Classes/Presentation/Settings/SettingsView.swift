//
//  SettingsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = SettingsViewModel()
    @State private var sheetType: SettingsSheet?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            SettingsItemView(item: item) {
//                                viewModel.open(item: item)
                                switch item {
                                case .date:
                                    sheetType = .bornDate
                                case .place:
                                    sheetType = .city
                                case .time:
                                    sheetType = .bornTime
                                case .privacyPolicy:
                                    break
                                case .termOfUse:
                                    break
                                case .contactUs:
                                    break
                                }
                            }
                            .padding(.vertical, 24)
                            .overlay(alignment: .bottom) {
                                if item.id != section.items.last?.id {
                                    Rectangle()
                                        .fill(.bgMain300)
                                        .frame(height: 1)
                                }
                            }
                        }
                    } header: {
                        Text(section.title.uppercased())
                            .font(Font.Gambarino.font(size: 18, weight: .w400))
                            .foregroundStyle(.textMain200.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                            .padding(.top, 32)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .appBackground()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                ProButton {
                    navigation.fullScreen(.paygate)
                }
            }
            
            ToolbarButton(placement: .topBarLeading) {
                Button(
                    action: { navigation.dismissFullScreen() },
                    label: { Image(systemName: "xmark") }
                )
                .foregroundStyle(.textMain200)
                .buttonStyle(.navigation)
            }
        }
        .screenState(viewModel.screenState, tryAgain: viewModel.load)
        .sheet(item: $sheetType) { type in
            Group {
                switch type {
                case .bornDate:
                    OnboardingBornDate(bornDate: viewModel.bornDate) {
                        viewModel.save(date: $0)
                        sheetType = nil
                    }
                case .bornTime:
                    OnboardingBornTime(bornTime: viewModel.bornDate) {
                        viewModel.save(date: $0)
                        sheetType = nil
                    }
                case .city:
                    OnboardingCityView(city: viewModel.city) {
                        viewModel.save(city: $0)
                        sheetType = nil
                    }
                }
            }
            .appBackground()
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(32)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

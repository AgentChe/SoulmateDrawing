//
//  SettingsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            SettingsItemView(item: item) {
                                viewModel.open(item: item)
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
                            .font(Font.Gambarino.font(size: 18.scale, weight: .w400))
                            .foregroundStyle(.textMain200.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8.scale)
                            .padding(.top, 32.scale)
                    }
                }
            }
            .padding(.horizontal, 24.scale)
        }
        .appBackground()
        .toolbar {
            if !viewModel.hasActiveSubscription {
                ToolbarButton(placement: .topBarTrailing) {
                    ProButton(action: viewModel.showPaygate)
                }
            }
            
            ToolbarButton(placement: .topBarLeading) {
                Button(
                    action: viewModel.close,
                    label: { Image(systemName: "xmark") }
                )
                .foregroundStyle(.textMain200)
                .buttonStyle(.navigation)
            }
        }
        .screenState(viewModel.screenState)
        .onAppear(perform: viewModel.checkActiveSubscription)
    }
}

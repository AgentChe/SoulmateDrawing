//
//  DreamerDetailsScreenView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.03.2026.
//

import SwiftUI
import NukeUI

struct DreamerDetailsScreenView: View {
//    @Environment(\.navigation) private var navigation
    @State var viewModel: DreamerDetailsViewModel
    @State private var headerHeight: CGFloat = 0
        @State private var topOffset: CGFloat = 0
    var body: some View {
        ZStack {
            Color.bgMain100
                .ignoresSafeArea()
            if viewModel.isLoading {
                DreamerDetailsLoading()
                    .navigationBarBackButtonHidden()
                    .closeButton(action: viewModel.close)
                    .transition(.opacity)
                    .screenState(viewModel.screenState)
            } else if let model = viewModel.model {
                content(for: model)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isLoading)
    }
    
    @ViewBuilder
    private func content(for model: DreamDetailsModel) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                Text("Dreamer.Details.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .padding(.horizontal, 40.scale)
                    .padding(.top, 284.scale)
                    .multilineTextAlignment(.center)
                
                Text(model.text)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .padding(.horizontal, 24.scale)
                    .padding(.bottom, 34.scale)
            }
            .foregroundStyle(.textMain200)
            .background(alignment: .top) {
                LazyImage(source: model.image) { state in
                    if let image = state.image {
                        image
                            .aspectRatio(1.09, contentMode: .fit)
                            .transition(.opacity)
                    } else {
                        Color.clear
                    }
                }
                .headerViewMask()
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .customBackButton()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: {},
                    label: {
                        Image("share")
                    }
                )
                .buttonStyle(.navigation)
            }
        }
        .ignoresSafeArea()
    }
}

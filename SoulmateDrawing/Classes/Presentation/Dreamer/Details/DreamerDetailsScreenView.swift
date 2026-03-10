//
//  DreamerDetailsScreenView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.03.2026.
//

import SwiftUI

struct DreamerDetailsScreenView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel: DreamerDetailsViewModel
    
    init(type: DreamerDetailsType) {
        _viewModel = .init(initialValue: .init(type: type))
    }
    
    var body: some View {
        ZStack {
            Color.bgMain100
                .ignoresSafeArea()
            if viewModel.isLoading {
                DreamerDetailsLoading()
                    .navigationBarBackButtonHidden()
                    .closeButton(action: navigation.pop)
                    .transition(.opacity)
            } else if let model = viewModel.model {
                content(for: model)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isLoading)
        .screenState(viewModel.screenState, tryAgain: viewModel.load)
    }
    
    @ViewBuilder
    private func content(for model: DreamDetailsModel) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                Text("Dreamer.Details.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .padding(.horizontal, 40.scale)
                    .padding(.top, 174.scale)
                    .multilineTextAlignment(.center)
                
                Text(model.text)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .padding(.horizontal, 24.scale)
            }
            .foregroundStyle(.textMain200)
        }
        .background(alignment: .top) {
            AsyncImage(
                url: model.image,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(1.09, contentMode: .fit)
                        .overlay(alignment: .top) {
                            let color = Color(red: 1, green: 240/255, blue: 223/255)
                            LinearGradient(
                                stops: [
                                    .init(color: color.opacity(0), location: 0.62),
                                    .init(color: color, location: 0.84)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .transition(.opacity)
                },
                placeholder: {
                    Color.clear
                }
            )
            .ignoresSafeArea()
        }
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
    }
}

#Preview {
    NavigationStack {
        DreamerDetailsScreenView(type: .interpret(dream: ""))
    }
}

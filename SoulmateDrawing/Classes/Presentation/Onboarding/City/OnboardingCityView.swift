//
//  OnboardingCityView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

struct OnboardingCityView: View {
    @FocusState private var isFocused: Bool
    @State private var viewModel: OnboardingCityViewModel
    var didTapContinue: (CityModel) -> Void
    
    
    init(city: String?, didTapContinue: @escaping (CityModel) -> Void) {
        self._viewModel = .init(initialValue: .init(city: city ?? ""))
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Born.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74.scale)
            
            TextField(text: $viewModel.cityText) {
                Text("Onboarding.City.Placeholder".localized)
                    .font(.system(size: 23.scale, weight: .regular))
            }
            .tint(.textMain200)
            .foregroundStyle(.textMain200)
            .padding(.top, 118.scale)
            .multilineTextAlignment(.center)
            .focused($isFocused)
            .keyboardType(.alphabet)
            
            if isFocused, !viewModel.cityList.isEmpty {
                cityListView
                    .transition(.opacity)
                    .padding(.top, 40)
            } else {
                Spacer()
                
            }
            
            if !isFocused {
                Button(
                    action: {
                        if let city = viewModel.city {
                            didTapContinue(city)
                        }
                    },
                    label: { Text("Continue") }
                )
                .buttonStyle(.primary)
                .padding(.horizontal, 24.scale)
                .disabled(viewModel.city == nil)
            }
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity, alignment: .center)
        .appBackground()
    }
    
    @ViewBuilder
    private var cityListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 11) {
                ForEach(viewModel.cityList) { model in
                    Button(
                        action: {
                            viewModel.didSelectCity(model)
                            isFocused = false
                        },
                        label: {
                            Text(model.address)
                                .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                                .foregroundStyle(.textMain200)
                        }
                    )
                    .onAppear {
                        if viewModel.cityList.last?.id == model.id {
                            viewModel.loadNext()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .background(.bgMain300, in: UnevenRoundedRectangle(topLeadingRadius: 32.scale, topTrailingRadius: 32.scale))
    }
}

#Preview {
    OnboardingCityView(city: "") { _ in }
        .appBackground()
}

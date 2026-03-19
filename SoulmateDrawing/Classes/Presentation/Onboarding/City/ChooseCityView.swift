//
//  ChooseCityView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

struct ChooseCityView: View {
    @FocusState private var isFocused: Bool
    @State private var viewModel: ChooseCityViewModel
    private let isOnboarding: Bool
    private var didTapContinue: (CityModel) -> Void
    
    
    init(city: String?, isOnboarding: Bool, didTapContinue: @escaping (CityModel) -> Void) {
        self._viewModel = .init(initialValue: .init(city: city ?? ""))
        self.isOnboarding = isOnboarding
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Born.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, isOnboarding ? 32.scale : 60.scale)
                .padding(.horizontal, 24.scale)
            
            TextField(text: $viewModel.cityText) {
                Text("Onboarding.City.Placeholder".localized)
                    .font(.system(size: 23.scale, weight: .regular))
                    .foregroundStyle(.textMain200.opacity(0.6))
            }
            .foregroundStyle(.textMain200)
            .padding(.top, 118.scale)
            .multilineTextAlignment(.center)
            .focused($isFocused)
            .keyboardType(.alphabet)
            .padding(.horizontal, 24.scale)
            
            if isFocused, !viewModel.cityList.isEmpty {
                tabel
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
        .frame(maxWidth: .infinity, alignment: .center)
        .animation(.easeInOut, value: isFocused)
        .animation(.easeInOut, value: viewModel.cityList.isEmpty)
        .appBackground()
    }
    
    @ViewBuilder
    private var stack: some View {
        ScrollView(.vertical) {
            Section {
                ForEach(viewModel.cityList) { model in
                    Text(model.address)
                        .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                        .foregroundStyle(.textMain200)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            viewModel.didSelectCity(model)
                            isFocused = false
                        }
                        .onAppear {
                            if viewModel.cityList.last?.id == model.id {
                                viewModel.loadNext()
                            }
                        }
                }
            } footer: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .progressViewStyle(.spinner)
                        .transition(.opacity)
                }
            }
        }
        .padding(.top, 16)
        .contentMargins(24.scale, for: .scrollContent)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 32.scale, topTrailingRadius: 32.scale)
                .fill(.bgMain300)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var tabel: some View {
        List {
            Section {
                ForEach(viewModel.cityList) { model in
                    Text(model.address)
                        .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                        .foregroundStyle(.textMain200)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    .onTapGesture {
                        viewModel.didSelectCity(model)
                        isFocused = false
                    }
                    .onAppear {
                        if viewModel.cityList.last?.id == model.id {
                            viewModel.loadNext()
                        }
                    }
                }
            } footer: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .progressViewStyle(.spinner)
                        .transition(.opacity)
                }
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
        }
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.never)
        .listStyle(.plain)
        .padding(.top, 16)
        .contentMargins(24.scale, for: .scrollContent)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 32.scale, topTrailingRadius: 32.scale)
                .fill(.bgMain300)
                .ignoresSafeArea()
        }
    }
}

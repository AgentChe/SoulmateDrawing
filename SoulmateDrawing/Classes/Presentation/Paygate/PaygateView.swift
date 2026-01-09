//
//  PaygateView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 06.01.2026.
//

import SwiftUI

struct PaygateView: View {
    @State private var viewModel = PaygateViewModel()
    
    var body: some View {
        VStack(spacing: ScreenSize.isIphoneXFamily ? 16 : 12) {
            Text("Paygate.Title")
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.mono100)
                .padding(.top, ScreenSize.isIphoneXFamily ? 162 : 84)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 16 : 12)
            
            advantagesView
            productView
        }
        .animation(.default, value: viewModel.isLoading)
        .frame(maxHeight: .infinity)
        .background {
            ZStack(alignment: .top) {
                Color.bgMain100
                Image(ScreenSize.isIphoneXFamily ? "Paygate.FaceID" : "Paygate.TouchID")
            }
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                Link(destination: GlobalDefinitions.termsOfUse) {
                    Text("Paygate.TermsOfUse".localized)
                }
                
                Link(destination: GlobalDefinitions.privacyPolicy) {
                    Text("Paygate.PrivacyPolicy".localized)
                }
                
                Button(action: viewModel.restore) {
                    Text("Paygate.RestorePurchases".localized)
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .font(Font.SFPro.font(size: 12, weight: .w510))
            .foregroundStyle(.textMain200)
            .opacity(0.6)
        }
        .task {
            await viewModel.load()
        }
    }
}

private extension PaygateView {
    @ViewBuilder
    var advantagesView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Image("Check")
                    Text("Paygate.Subtitle1".localized)
                }
                
                HStack(spacing: 10) {
                    Image("Check")
                    Text("Paygate.Subtitle2".localized)
                }
                HStack(spacing: 10) {
                    Image("Check")
                    Text("Paygate.Subtitle3".localized)
                }
            }
            .font(Font.SFPro.font(size: 15, weight: .w400))
            .foregroundStyle(.mono100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 50)
        }
    }
    
    @ViewBuilder
    var productView: some View {
        if let trial = viewModel.products?.weekly, let yearly = viewModel.products?.yearly, !viewModel.isLoading {
            VStack(spacing: 16) {
                Toggle(isOn: $viewModel.isOnTrial) {
                    Text("Paygate.Yearly.Toggle")
                }
                .toggleStyle(.paygate)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.bgMain200, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(lineWidth: 1)
                        .fill(.bgMain300)
                }
                
                makeYearly(yearly)
                makeTrial(trial)
                
                Button(
                    action: viewModel.byProduct,
                    label: { Text(viewModel.currentProduct.actionTitle) }
                )
                .buttonStyle(.primary)
                
                Label(viewModel.currentProduct.securityLabel, image: "Security")
                    .font(Font.SFPro.font(size: 12, weight: .w510))
                    .foregroundStyle(.textMain200)
                
                Spacer()
            }
            .padding(.horizontal, 22)
        } else {
            SpinnerView()
                .frame(maxHeight: .infinity)
        }
    }
}

private extension PaygateView {
    
    @ViewBuilder
    func makeYearly(_ product: ProductPrice) -> some View {
        let priceLeft = Currency(productPrice: product).formatted() ?? ""
        let priceRight = Currency(productPrice: product, div: 52).formatted() ?? ""
        
        Button(
            action: {
                withAnimation {
                    viewModel.isOnTrial = false
                }
            },
            label: {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Paygate.Yearly".localized)
                            .font(Font.SFPro.font(size: 12, weight: .w510))
                        Text(String(format: "Paygate.Yearly.Bottom".localized, priceLeft))
                            .font(Font.SFPro.font(size: 15, weight: .w400))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(priceRight)
                            .font(Font.SFPro.font(size: 15, weight: .w400))
                        Text("Paygate.PerWeek".localized)
                            .font(Font.SFPro.font(size: 12, weight: .w510))
                    }
                    .padding(.trailing, 40)
                    
                    Image(viewModel.currentProduct == .yearly ? "Radiobutton.Selected" : "Radiobutton.Default")
                }
                .foregroundStyle(.mono100)
            }
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bgMain200, in: Capsule())
        .overlay {
            Capsule()
                .stroke(lineWidth: viewModel.currentProduct == .yearly ? 2 : 1)
                .fill(viewModel.currentProduct == .yearly ? .textMain200 : .bgMain300)
        }
    }
    
    @ViewBuilder
    func makeTrial(_ product: ProductPrice) -> some View {
        let price = Currency(productPrice: product).formatted() ?? ""
        
        Button(
            action: {
                withAnimation {
                    viewModel.isOnTrial = true
                }
            },
            label: {
                HStack(spacing: 0) {
                    Text("Paygate.FreeTrialDays".localized.uppercased())
                        .font(Font.SFPro.font(size: 15, weight: .w400))
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(price)
                            .font(Font.SFPro.font(size: 15, weight: .w400))
                        Text("Paygate.PerWeek".localized)
                            .font(Font.SFPro.font(size: 12, weight: .w510))
                    }
                    .padding(.trailing, 40)
                    
                    
                    Image(viewModel.currentProduct == .trial ? "Radiobutton.Selected" : "Radiobutton.Default")
                }
            }
        )
        .foregroundStyle(.mono100)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bgMain200, in: Capsule())
        .overlay {
            Capsule()
                .stroke(lineWidth: viewModel.currentProduct == .trial ? 2 : 1)
                .fill(viewModel.currentProduct == .trial ? .textMain200 : .bgMain300)
        }
    }
}

private extension PaygateProduct {
    var actionTitle: String {
        switch self {
        case .trial:
            "Paygate.Trial.Action".localized
        case .yearly:
            "Paygate.Yearly.Action".localized
        }
    }
    
    var securityLabel: String {
        switch self {
        case .trial:
            "Paygate.Trial.Security".localized
        case .yearly:
            "Paygate.Yearly.Security".localized
        }
    }
}

#Preview {
    NavigationStack {
        PaygateView()
    }
}

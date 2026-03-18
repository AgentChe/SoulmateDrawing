//
//  SoulmateCheckProfileScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 28.01.2026.
//

import SwiftUI

struct SoulmateCheckProfileScreen: View {
    @State var viewModel: SoulmateCheckProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isGenerateSoulmate {
                SoulmateGenerateView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            } else {
                SoulmateProfileView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            }
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity)
        .appBackground()
        .closeButton(action: viewModel.close)
    }
}

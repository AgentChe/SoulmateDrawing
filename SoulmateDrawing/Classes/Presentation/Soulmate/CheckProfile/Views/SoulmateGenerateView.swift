//
//  SoulmateGenerateView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI

struct SoulmateGenerateView: View {
    @Bindable var viewModel: SoulmateCheckProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Soulmate.Generate.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12.scale)
            
            Text("Soulmate.Generate.Subtitle".localized)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40.scale)
            
            RoundedRectangle(cornerRadius: 32.scale)
                .fill(Color(red: 1, green: 251/255, blue: 245/255))
                .aspectRatio(0.98, contentMode: .fit)
                .overlay {
                    ZStack {
                        Image("SoulmatePlaceholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .blur(radius: 20)
                        
                        ProgressView()
                            .progressViewStyle(.spinner)
                    }
                    .padding(26.scale)
                }
                .clipShape(RoundedRectangle(cornerRadius: 32.scale))
        }
        .screenState(viewModel.screenState)
    }
}

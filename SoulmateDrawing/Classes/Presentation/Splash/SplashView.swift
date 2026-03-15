//
//  LoadingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI
import RiveRuntime

struct SplashView: View {
    private let model = RiveViewModel(fileName: "splash_screen", autoPlay: true)
    
    var body: some View {
        VStack {
            Spacer()
            
            ProgressView()
                .progressViewStyle(.spinner)
                .padding(.bottom, 65.scale)
        }
        .frame(maxWidth: .infinity)
        .background {
            model.view()
                .ignoresSafeArea()
        }
        .appBackground()
    }
}

#Preview {
    SplashView()
}

//
//  DreamerMainScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.02.2026.
//

import SwiftUI

struct DreamerMainScreen: View {
//    @Environment(\.navigation) private var navigation
//    @State private var text: String = ""
    @State var viewModel: DreamerMainViewModel
    
    @FocusState private var isFocused
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24.scale) {
                TextField("Dreamer.Placeholder".localized, text: $viewModel.text, axis: .vertical)
                    .frame(height: 300.scale, alignment: .top)
                    .padding(24.scale)
                    .background(.bgMain400, in: RoundedRectangle(cornerRadius: 32.scale))
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .onTapGesture { isFocused = true }
                    .focused($isFocused)
                
                if !viewModel.text.isEmpty {
                    Button(
                        action: {
                            viewModel.showDetails()
//                            navigation.push(.dreamerDetails(type: .interpret(dream: text)))
                        },
                        label: {
                            Text("Dreamer.Interpret".localized)
                        }
                    )
                    .buttonStyle(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24.scale)
            .frame(maxWidth: .infinity)
        }
        .contentMargins(.top, 24.scale)
        .bluredNavigationBar()
        .appBackground()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: {
                        viewModel.showHistory()
//                        navigation.push(.dreamerHistory)
                    },
                    label: { Image(systemName: "line.3.horizontal") }
                )
                .buttonStyle(.navigation)
            }
            
            ToolbarItem(placement: .principal) {
                Text("Dreamer.Title".localized)
                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

//
//  DreamerHistoryScreenView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import SwiftUI

struct DreamerHistoryScreenView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = DreamHistoryViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.items) { item in
                    Button(
                        action: { navigation.push(.dreamerDetails(type: .load(id: item.id))) },
                        label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.date)
                                    .font(Font.SFPro.font(size: 17, weight: .w400))
                                    .foregroundStyle(.textMain200.opacity(0.8))
                                
                                HStack(spacing: 0) {
                                    Text(item.text)
                                        .lineLimit(2)
                                        .font(Font.Gambarino.font(size: 22, weight: .w400))
                                        .foregroundStyle(.textMain200)
                                    Spacer(minLength: 24)
                                    
                                    AsyncImage(url: item.image) { image in
                                        image
                                            .resizable()
                                    } placeholder: {
                                        Color.clear
                                    }
                                    .frame(width: 45, height: 50)
                                    .clipShape(Circle())
                                }
                            }
                            .padding(24)
                            .background(.bgMain200, in: RoundedRectangle(cornerRadius: 32))
                        }
                    )
                    .buttonStyle(.card)
                    .itemShadow()
                }
            }
        }
        .contentMargins(.horizontal, 24)
        .appBackground()
        .screenState(viewModel.screenState, tryAgain: viewModel.load)
        .customBackButton()
    }
}

#Preview {
    NavigationStack {
        DreamerHistoryScreenView()
    }
}

//
//  BondsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import SwiftUI
import NukeUI

struct BondsView: View {
    @State var viewModel: BondsViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Text("Bonds.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .padding(.top, 22.scale)
                    .padding(.horizontal, 40.scale)
                
                Text("Bonds.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12.scale)
                    .padding(.bottom, 24.scale)
                    .padding(.horizontal, 40.scale)
                    .foregroundStyle(.textMain200)
                
                HStack(spacing: 12.scale) {
                    LazyImage(source: viewModel.userSign) { state in
                        if let image = state.image {
                            image
                        } else {
                            Circle()
                                .fill(.bgMain300)
                        }
                    }
                    .frame(width: 45.scale, height: 45.scale)
                    
                    Button(
                        action: {},
                        label: {
                            Text("Bonds.You".localized)
                                .frame(maxWidth: .infinity)
                        }
                    )
                    .buttonStyle(SelectorButtonStyle())
                }
                .padding(.horizontal, 40.scale)
                
                HStack(spacing: 12.scale) {
                    LazyImage(source: viewModel.person?.singImage) { state in
                        if let image = state.image {
                            image
                        } else {
                            Circle()
                                .fill(.bgMain300)
                        }
                    }
                    .frame(width: 45.scale, height: 45.scale)
                    
                    Button(
                        action: viewModel.openPersonList,
                        label: {
                            Text(viewModel.person?.name ?? "Bonds.Person".localized)
                                .frame(maxWidth: .infinity)
                                .overlay(alignment: .trailing) {
                                    Image("Down")
                                        .padding(.trailing, 16.scale)
                                }
                        }
                    )
                }
                .buttonStyle(SelectorButtonStyle())
                .padding(.top, 12.scale)
                .padding(.horizontal, 40.scale)
                
                Button(
                    action: viewModel.openConnectionType,
                    label: {
                        Text(viewModel.connectionType?.title ?? "Bonds.ConnectionType".localized).frame(maxWidth: .infinity)
                            .overlay(alignment: .trailing) {
                                Image("Down")
                                    .padding(.trailing, 16.scale)
                            }
                    }
                )
                .buttonStyle(SelectorButtonStyle())
                .padding(.top, 12.scale)
                .padding(.horizontal, 40.scale)
                
                Button(
                    action: viewModel.tapDiscover,
                    label: {
                        Text("Bonds.Button".localized)
                    }
                )
                .buttonStyle(.primary)
                .padding(.top, 24.scale)
                .disabled(!viewModel.actionIsEnabled || viewModel.isDescovering)
                .padding(.horizontal, 40.scale)
                .loading(viewModel.isDescovering)
                
                if !viewModel.insights.isEmpty {
                    HStack {
                        Text("Bonds.Insights".localized)
                            .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                            .foregroundStyle(.textMain200)
                        Spacer()
                        
                        Button(
                            action: viewModel.openInsightList,
                            label: {
                                Text("Bonds.SeeAll".localized)
                                    .padding(.horizontal, 12.scale)
                                    .padding(.vertical, 10.scale)
                                    .foregroundStyle(.textMain200)
                                    .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                            }
                        )
                        .background(.bgMain300)
                        .clipShape(Capsule())
                    }
                    .padding(.init(top: 40.scale, leading: 24.scale, bottom: 16.scale, trailing: 24.scale))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16.scale) {
                            ForEach(viewModel.insights) { model in
                                Button(
                                    action: {
                                        viewModel.openChat(model: model)
                                    },
                                    label: {
                                        BondsInsightCard(model: model)
                                    }
                                )
                                .frame(width: 322.scale)
                                .buttonStyle(.card)
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .contentMargins(.horizontal, 24.scale)
                }
                
                Spacer()
            }
        }
        .bluredNavigationBar()
        .appBackground()
        .frame(maxWidth: .infinity)
        .screenState(viewModel.screenState)
    }
}

struct SelectorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.bgMain300
            configuration.label
                .foregroundStyle(.textMain200)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
        }
        .frame(height: 50.scale)
        .clipShape(Capsule())
    }
}

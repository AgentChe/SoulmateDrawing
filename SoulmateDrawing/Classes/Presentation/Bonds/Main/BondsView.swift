//
//  BondsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import SwiftUI
import NukeUI

struct BondsView: View {
    @Environment(\.navigation) private var navigation
    @State private var viewModel = BondsViewModel()
    @State private var sheetType: BondsSheetType?
    @State private var isShowPaygate = false
    
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
                        action: {
                            sheetType = viewModel.persons.isEmpty ? .createPerson : .persons
                        },
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
                    action: {
                        sheetType = .connectionType
                    },
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
                    action: {
                        if viewModel.hasActiveSubscription {
                            viewModel.tapDiscover()
                        } else {
                            isShowPaygate = true
                        }
                    },
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
                            action: {
                                navigation.push(.insightsList(viewModel.insights))
                            },
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
                                        navigation.push(.chat(.open(threadID: model.id)))
                                    },
                                    label: {
                                        BondsInsightCard(model: model)
                                    }
                                )
                                .frame(width: 322.scale)
                                .buttonStyle(.card)
                            }
                            
                            if viewModel.isAvailablePagination {
                                ProgressView()
                                    .progressViewStyle(.spinner)
                                    .onAppear {
                                        viewModel.getNextPage()
                                    }
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
        .sheet(item: $sheetType) { type in
            switch type {
            case .persons:
                NavigationStack {
                    PersonList(persons: viewModel.persons) {
                        viewModel.selectPerson(person: $0)
                        sheetType = nil
                    }
                }
            case .connectionType:
                ConnectionTypeView {
                    viewModel.selectConnectionType($0)
                    sheetType = nil
                }
            case .createPerson:
                NavigationStack {
                    NewPersonView {
                        viewModel.selectPerson(person: $0)
                        sheetType = nil
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowPaygate) {
            NavigationStack {
                PaygateView()
            }
        }
        .onChange(of: viewModel.push, { _, newValue in
            guard let newValue else { return }
            navigation.push(newValue)
            viewModel.push = nil
        })
        .screenState(viewModel.screenState) {
            viewModel.load()
        }
        .task {
            viewModel.load()
        }
    }
}

struct BondsInsightCard: View {
    let model: InsightModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.formattedDate)
                .opacity(0.8)
                .padding(.bottom, 4.scale)
            
            Text(model.text)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 24.scale)
            
            HStack(spacing: 4.scale) {
                Text(model.pairText)
                Text(model.connectionType.title)
                    .padding(.horizontal, 12.scale)
                    .padding(.vertical, 6.scale)
                    .background(.bgMain300, in: Capsule())
            }
            .font(Font.SFPro.font(size: 17.scale, weight: .w510))
        }
        .foregroundStyle(.textMain200)
        .padding(24.scale)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.bgMain200)
        .clipShape(RoundedRectangle(cornerRadius: 32.scale))
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

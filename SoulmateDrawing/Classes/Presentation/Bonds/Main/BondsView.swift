//
//  BondsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import SwiftUI

struct BondsView: View {
//    @Environment(Coordinator<BondsRoute>.self) var coordinator
    @Environment(\.navigation) private var navigation
    @State private var viewModel = BondsViewModel()
    @State private var sheetType: BondsSheetType?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Text("Bonds.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .padding(.top, 22)
                    .padding(.horizontal, 40)
                
                Text("Bonds.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 40)
                    .foregroundStyle(.textMain200)
                
                HStack(spacing: 12) {
                    Button(
                        action: {},
                        label: {
                            Text("Bonds.You".localized)
                                .frame(maxWidth: .infinity)
                        }
                    )
                    .buttonStyle(SelectorButtonStyle())
                }
                .padding(.horizontal, 40)
                
                HStack(spacing: 12) {
                    if let image = viewModel.person?.singImage {
                        AsyncImage(url: image)
                    } else {
                        Circle()
                            .fill(.bgMain300)
                            .frame(width: 45)
                    }
                    
                    Button(
                        action: {
                            sheetType = viewModel.persons.isEmpty ? .createPerson : .persons
                            //                        coordinator.sheet(.personList(
                            //                            persons: viewModel.persons, selected: { viewModel.person = $0 }))
                        },
                        label: {
                            Text(viewModel.person?.name ?? "Bonds.Person".localized)
                                .frame(maxWidth: .infinity)
                                .overlay(alignment: .trailing) {
                                    Image("Down")
                                        .padding(.trailing, 16)
                                }
                        }
                    )
                }
                .buttonStyle(SelectorButtonStyle())
                .padding(.top, 12)
                .padding(.horizontal, 40)
                
                Button(
                    action: {
                        //                    coordinator.sheet(.connectionType)
                        sheetType = .connectionType
                    },
                    label: {
                        Text(viewModel.connectionType?.title ?? "Bonds.ConnectionType".localized).frame(maxWidth: .infinity)
                            .overlay(alignment: .trailing) {
                                Image("Down")
                                    .padding(.trailing, 16)
                            }
                    }
                )
                .buttonStyle(SelectorButtonStyle())
                .padding(.top, 12)
                .padding(.horizontal, 40)
                
                Button(
                    action: {
                        viewModel.tapDiscover()
                    },
                    label: {
                        Text("Bonds.Button".localized)
                    }
                )
                .buttonStyle(.primary)
                .padding(.top, 24)
                .disabled(!viewModel.actionIsEnabled || viewModel.isDescovering)
                .padding(.horizontal, 40)
                .loading(viewModel.isDescovering)
                
                if !viewModel.insights.isEmpty {
                    HStack {
                        Text("Bonds.Insights".localized)
                            .font(Font.Gambarino.font(size: 22, weight: .w400))
                            .foregroundStyle(.textMain200)
                        Spacer()
                        
                        Button(
                            action: {
                                //                            coordinator.push(.insightsList(models: viewModel.insights))
                                navigation.push(.insightsList(viewModel.insights))
                            },
                            label: {
                                Text("Bonds.SeeAll".localized)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(.textMain200)
                                    .font(Font.SFPro.font(size: 17, weight: .w510))
                            }
                        )
                        .background(.bgMain300)
                        .clipShape(Capsule())
                    }
                    .padding(.init(top: 40, leading: 24, bottom: 16, trailing: 24))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.insights) { model in
                                Button(
                                    action: {
                                        navigation.push(.chat(threadID: model.id))
                                    },
                                    label: {
                                        BondsInsightCard(model: model)
                                    }
                                )
                                .frame(width: 322)
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
                    .contentMargins(.horizontal, 24)
                }
                
                Spacer()
            }
        }
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
        .screenState(viewModel.screenState) {
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
                .padding(.bottom, 4)
            
            Text(model.text)
                .font(Font.Gambarino.font(size: 22, weight: .w400))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 24)
            
            HStack(spacing: 4) {
                Text(model.pairText)
                Text(model.connectionType.title)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.bgMain300, in: Capsule())
            }
            .font(Font.SFPro.font(size: 17, weight: .w510))
        }
        .foregroundStyle(.textMain200)
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.bgMain200)
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

struct SelectorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.bgMain300
            configuration.label
                .foregroundStyle(.textMain200)
                .font(Font.Gambarino.font(size: 22, weight: .w400))
        }
        .frame(height: 50)
        .clipShape(Capsule())
    }
}

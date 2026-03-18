//
//  PersonList.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct PersonList: View {
    @State var viewModel: PersonListViewModel
    
    var body: some View {
        VStack(spacing: 32.scale) {
            Text("ChoosePerson.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 60.scale)
                .padding(.horizontal, 24.scale)
            
            Button(
                action: viewModel.createNew,
                label: {
                    Text("ChoosePerson.Add".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            
            List {
                Section {
                    ForEach(viewModel.persons) { person in
                        PersonListItem(person: person) {
                            viewModel.select(person: $0)
                        }
                        .onAppear {
                            if viewModel.persons.last == person {
                                viewModel.loadNext()
                            }
                        }
                    }
                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    
                } footer: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .progressViewStyle(.spinner)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
            }
            .listRowSpacing(12.scale)
            .scrollContentBackground(.hidden)
            .contentMargins(24.scale, for: .scrollContent)
            .listStyle(.plain)
            
//            ScrollView(.vertical) {
//                LazyVStack(spacing: 12.scale) {
//                    ForEach(viewModel.persons) { person in
//                        Button(
//                            action: {
//                                viewModel.select(person: person)
//                            },
//                            label: {
//                                HStack(spacing: 12.scale) {
//                                    LazyImage(source: person.singImage) { state in
//                                        if let image = state.image {
//                                            image
//                                        } else {
//                                            Circle()
//                                                .fill(.main300)
//                                        }
//                                    }
//                                    .frame(width: 45.scale, height: 50.scale)
//                                    .padding(.vertical, 2.scale)
//                                    
//                                    Text(person.name)
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                        )
//                        .onAppear {
//                            
//                        }
//                    }
//                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
//                    .foregroundStyle(.textMain200)
//                }
//                .padding(.horizontal, 24.scale)
//            }
        }
        .frame(maxWidth: .infinity)
        .appBackground()
    }
}

//
//  PersonList.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI
import NukeUI

struct PersonList: View {
    @State private var viewModel: PersonListViewModel
    private let selected: (PersonModel) -> Void
    
    @State var showSheet = false
    
    init(persons: [PersonModel], selected: @escaping (PersonModel) -> Void) {
        _viewModel = State(initialValue: .init(persons: persons))
        self.selected = selected
    }
    
    var body: some View {
        VStack(spacing: 32.scale) {
            Text("ChoosePerson.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 60.scale)
                .padding(.horizontal, 24.scale)
            
            Button(
                action: {
                    showSheet = true
                },
                label: {
                    Text("ChoosePerson.Add".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12.scale) {
                    ForEach(viewModel.persons) { person in
                        Button(
                            action: {
                                selected(person)
                            },
                            label: {
                                HStack(spacing: 12.scale) {
                                    LazyImage(source: person.singImage) { state in
                                        if let image = state.image {
                                            image
                                        } else {
                                            Circle()
                                                .fill(.main300)
                                        }
                                    }
                                    .frame(width: 45.scale, height: 50.scale)
                                    .padding(.vertical, 2.scale)
                                    
                                    Text(person.name)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        )
                    }
                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                }
                .padding(.horizontal, 24.scale)
            }
        }
        .frame(maxWidth: .infinity)
        .appBackground()
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32.scale)
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                NewPersonView(createdPerson: selected)
            }
        }
    }
}

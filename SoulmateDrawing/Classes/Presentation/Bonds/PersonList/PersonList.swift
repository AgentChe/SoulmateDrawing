//
//  PersonList.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct PersonList: View {
//    @Environment(Coordinator<SelectPersonRoute>.self) private var coordinator
    @State private var viewModel: PersonListViewModel
    private let selected: (PersonModel) -> Void
    
    @State var showSheet = false
    
    init(persons: [PersonModel], selected: @escaping (PersonModel) -> Void) {
        _viewModel = State(initialValue: .init(persons: persons))
        self.selected = selected
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Text("ChoosePerson.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Button(
                action: {
                    showSheet = true
//                    coordinator.sheet(.create(created: selected))
                },
                label: {
                    Text("ChoosePerson.Add".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.persons) { person in
                        Button(
                            action: {
                                selected(person)
                            },
                            label: {
                                HStack(spacing: 12) {
                                    Circle()
                                        .frame(width: 45, height: 50)
                                        .padding(.vertical, 2)
                                        .overlay {
                                            AsyncImage(url: person.singImage)
                                        }
                                    
                                    Text(person.name)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        )
                    }
                    .font(Font.Gambarino.font(size: 22, weight: .w400))
                    .foregroundStyle(.textMain200)
                }
                .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity)
        .appBackground()
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                NewPersonView(createdPerson: selected)
            }
        }
    }
}

//#Preview {
//    PersonList(persons: [
//        .init(type: .friend, items: [
//            .init(id: "1", name: "Megan", singImage: nil),
//            .init(id: "2", name: "Megan1", singImage: nil),
//            .init(id: "3", name: "Megan2", singImage: nil),
//            .init(id: "4", name: "Megan3", singImage: nil)
//        ]),
//        .init(type: .partner, items: [
//            .init(id: "5", name: "Fox", singImage: nil),
//            .init(id: "6", name: "Fox1", singImage: nil),
//            .init(id: "7", name: "Fox2", singImage: nil),
//            .init(id: "8", name: "Fox3", singImage: nil)
//        ])
//    ]) { _ in }
//}

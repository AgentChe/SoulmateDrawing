//
//  NewPersonView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.01.2026.
//

import SwiftUI

struct NewPersonView: View {
    @State var viewModel: NewPersonViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("NewPerson.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.scale)
                .padding(.top, 60.scale)
            
            ScrollView(.vertical) {
                SegmentView(
                    elements: GenderModel.allCases,
                    selection: $viewModel.gender
                ) { value in
                    Text(value.name)
                        .font(Font.SFPro.font(size: 16.scale, weight: .w510))
                        .foregroundStyle(.textMain200)
                }
                .padding(.vertical, 24.scale)
                
                VStack(spacing: 12.scale) {
                    NewPersonTextField(
                        placeholder: "NewPerson.Placeholder.FirstName".localized,
                        text: $viewModel.name
                    )
                    
                    Button(
                        action: viewModel.openCity,
                        label: {
                            NewPersonInputView(
                                text: viewModel.city?.address ?? "",
                                placeholder: "NewPerson.Placeholder.PlaceOfBirth".localized
                            )
                        }
                    )
                    
                    Button(
                        action: viewModel.openBornDate,
                        label: {
                            NewPersonInputView(
                                text: viewModel.dayOfBorn?.formatted(date: .long, time: .omitted) ?? "",
                                placeholder: "NewPerson.Placeholder.DateOfBirth".localized
                            )
                        }
                    )
                    
                    Button(
                        action: viewModel.openBornTime,
                        label: {
                            NewPersonInputView(
                                text: viewModel.timeOfBorn?.formatted(date: .omitted, time: .shortened) ?? "",
                                placeholder: "NewPerson.Placeholder.TimeOfBirth".localized
                            )
                        }
                    )
                    .disabled(viewModel.isKnownExtractTime)
                    
                    Toggle("NewPerson.SwitchTitle".localized, isOn: $viewModel.isKnownExtractTime)
                        .toggleStyle(NewPersonToggleStyle())
                        .foregroundStyle(.textMain200)
                        .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24.scale)
            }
            .scrollDismissesKeyboard(.immediately)
            
            Spacer()
            Button("Save".localized) {
                viewModel.save()
            }
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            .disabled(!viewModel.isAvailableSave || viewModel.isSaving)
            .loading(viewModel.isSaving)
            
            Text("NewPerson.PrivacyMessage".localized)
                .font(Font.SFPro.font(size: 12.scale, weight: .w510))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.scale)
                .opacity(0.6)
                .padding(.top, 16.scale)
        }
        .frame(maxWidth: .infinity)
        .appBackground()
        .ignoresSafeArea(.keyboard)
        .screenState(viewModel.screenState)
    }
}

struct NewPersonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(.bgMain300)
                .overlay {
                    if configuration.isOn {
                        Image("bgpro")
                    }
                }
                .overlay(alignment: .leading) {
                    if configuration.isOn {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 1)
                            .padding(.vertical, 9.scale)
                            .padding(.leading, 12.scale)
                    }
                }
                .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                    Capsule()
                        .fill(.white)
                        .frame(width: 39.scale)
                        .padding(2.scale)
                }
                .frame(width: 64.scale, height: 28.scale)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
                .clipShape(Capsule())
            
            configuration.label
        }
    }
}

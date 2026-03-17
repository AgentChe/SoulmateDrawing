//
//  ChatViewScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import SwiftUI

struct ChatViewScreen: View {
    @State var viewModel: ChatScreenViewModel
    @State private var isPresentDeleteAlert = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 24.scale) {
            if viewModel.isShowSkeleton {
                ChatSkeleton()
                    .padding([.horizontal, .top], 24.scale)
                    .transition(.opacity)
            } else if let tipsDataSource = viewModel.tipsDataSource {
                tipsContent(for: tipsDataSource)
            } else {
                chatList.transition(.opacity)
            }
            
            ChatInputFieldView(
                currentText: $viewModel.currentText,
                action: {
                    isFocused = false
                    viewModel.sendMessage()
                }
            )
            .disabled(viewModel.isThinking || viewModel.isShowSkeleton)
            .focused($isFocused)
        }
        .scrollDismissesKeyboard(.immediately)
        .animation(.easeInOut, value: viewModel.dataSource)
        .frame(maxWidth: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4.scale) {
                    Text(viewModel.personName)
                        .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    Text(viewModel.personType.title)
                        .padding(.horizontal, 12.scale)
                        .padding(.vertical, 6.scale)
                        .background(.bgMain300, in: Capsule())
                        .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                        .layoutPriority(1)
                }
                .foregroundStyle(.textMain200)
            }
            
            ToolbarButton(placement: .topBarTrailing) {
                Menu(
                    content: {
                        Button(
                            role: .destructive,
                            action: viewModel.showDeleteAlert,
                            label: { Label("Chat.DeleteTitle".localized, systemImage: "trash") }
                        )
                            
                    },
                    label: {
                        Button(
                            action: {},
                            label: { Image(systemName: "ellipsis") }
                        )
                        .buttonStyle(.navigation)
                    }
                )
            }
        }
        .bluredNavigationBar()
        .appBackground()
        .onChange(of: isFocused) { _, newValue in
            if newValue, viewModel.tipsDataSource != nil {
                withAnimation {
                    viewModel.tipsDataSource = nil
                }
            }
        }
        .screenState(viewModel.screenState)
        .customBackButton()
    }
    
    @ViewBuilder
    private var chatList: some View {
        ScrollViewReader { proxy in
            List {
                Section(
                    content: {
                        ForEach(viewModel.dataSource) { message in
                            ChatMessageView(model: message)
                                .id(message.id)
                                .onAppear {
                                    viewModel.loadNext(id: message.id)
                                }
                        }
                        .font(Font.system(size: 17.scale))
                        .foregroundStyle(.textMain200)
                        .multilineTextAlignment(.leading)
                    },
                    header: {
                        if viewModel.isMessagesLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .progressViewStyle(.spinner)
                                .transition(.opacity)
                        }
                    },
                    footer: {
                        if viewModel.isShowRetry {
                            ChatRetryView(action: viewModel.retryMessageAction)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40.scale)
                        }
                        
                        if viewModel.isThinking {
                            ThinkingView()
                                .transition(.opacity)
                        }
                    }
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
            }
            .listRowSpacing(16.scale)
            .contentMargins(24.scale, for: .scrollContent)
            .scrollContentBackground(.hidden)
            .onAppear {
                proxy.scrollTo(viewModel.dataSource.last?.id, anchor: .bottom)
            }
            .animation(.easeInOut, value: viewModel.dataSource)
            .scrollPosition(id: $viewModel.scrollPosition, anchor: .bottom)
            .onChange(of: viewModel.scrollToSendedMessage) { _, newValue in
                if let newValue {
                    proxy.scrollTo(newValue, anchor: .bottom)
                }
            }
        }
    }
    
//    @ViewBuilder
//    private var content: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            LazyVStack(spacing: 16.scale) {
//                if viewModel.isShowRetry {
//                    ChatRetryView(action: viewModel.retryMessageAction)
//                    .padding(.top, 40.scale)
//                    .rotationEffect(.degrees(180))
//                }
//                
//                if viewModel.isThinking {
//                    ThinkingView()
//                        .transition(.opacity)
//                }
//                
//                ForEach(viewModel.dataSource.reversed()) { message in
//                    ChatMessageView(model: message)
//                        .onAppear {
//                            if viewModel.dataSource.last == message {
//                                viewModel.loadNext()
//                            }
//                        }
//                }
//                .font(Font.system(size: 17.scale))
//                .foregroundStyle(.textMain200)
//                .multilineTextAlignment(.leading)
//                .rotationEffect(.degrees(180))
//                
//                if viewModel.isMessagesLoading {
//                    ProgressView()
//                        .progressViewStyle(.spinner)
//                        .transition(.opacity)
//                }
//            }
//        }
//        .rotationEffect(.degrees(180))
//        .contentMargins(24.scale, for: .scrollContent)
//    }
    
    @ViewBuilder
    private func tipsContent(for source: ChatTipsSource) -> some View {
        VStack(spacing: 0) {
            ChatMessageView(model: source.insight)
            Spacer()
            ForEach(source.tips) { model in
                ChatMessageView(model: model)
                    .padding(.top, 16.scale)
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ChatFieldAlignmentID: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[VerticalAlignment.center]
    }
}

extension VerticalAlignment {
    static let chatField = VerticalAlignment(ChatFieldAlignmentID.self)
}
//
//#Preview {
//    NavigationStack {
//        ChatViewScreen(model: .open(threadID: ""))
//    }
//}

//
//  ChatViewScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import SwiftUI

struct ChatViewScreen: View {
    @State private var viewModel: ChatScreenViewModel
    @State private var isPresentDeleteAlert = false
    @Namespace private var insight
    @FocusState private var isFocused: Bool
    
    init(model: ChatInitialModel) {
        _viewModel = State(initialValue: .init(initialModel: model))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isShowSkeleton {
                ChatSkeleton()
                    .padding([.horizontal, .top], 24.scale)
                    .transition(.opacity)
            } else if let tipsDataSource = viewModel.tipsDataSource {
                tipsContent(for: tipsDataSource)
            } else {
                content.transition(.opacity)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .animation(.easeInOut, value: viewModel.dataSource)
        .frame(maxWidth: .infinity)
        .customBackButton()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4.scale) {
                    Text("MargoMargoMargoMargo")
                        .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    Text(ConnectionType.friend.title)
                        .padding(.horizontal, 12.scale)
                        .padding(.vertical, 6.scale)
                        .background(.bgMain300, in: Capsule())
                        .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                }
                .foregroundStyle(.textMain200)
            }
            
            ToolbarButton(placement: .topBarTrailing) {
                Menu(
                    content: {
                        Button(
                            role: .destructive,
                            action: { isPresentDeleteAlert = true },
                            label: {
                                Label("Chat.DeleteTitle".localized, systemImage: "trash")
                            }
                        )
                            
                    },
                    label: {
                        Button(
                            action: {},
                            label: {
                                Image(systemName: "ellipsis")
                            }
                        )
                        .buttonStyle(.navigation)
                    }
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            ChatInputFieldView(
                currentText: $viewModel.currentText,
                isFocused: $isFocused,
                action: viewModel.sendMessage
            )
            .disabled(viewModel.isThinking || viewModel.isShowSkeleton)
        }
        .customTabBarVisible(false)
        .alert("Chat.DeleteTitle".localized, isPresented: $isPresentDeleteAlert) {
            Button(
                role: .cancel,
                action: { isPresentDeleteAlert = false },
                label: { Text("Chat.Cancel".localized) }
            )
            .foregroundStyle(.textMain200)
            
            Button(
                role: .destructive,
                action: viewModel.deleteChat,
                label: { Text("Chat.Delete".localized) }
            )
        } message: {
            Text("Chat.DeleteMessage".localized)
                .foregroundStyle(.textMain200)
        }
        .appBackground()
        .screenState(viewModel.screenState, tryAgain: viewModel.deleteChat)
        .onChange(of: isFocused) { _, newValue in
            if newValue, viewModel.tipsDataSource != nil {
                withAnimation {
                    viewModel.tipsDataSource = nil
                }
            }
        }
        .task {
            viewModel.load()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16.scale) {
                if viewModel.isShowRetry {
                    ChatRetryView(action: viewModel.retryMessageAction)
                    .padding(.top, 40.scale)
                    .rotationEffect(.degrees(180))
                }
                
                if viewModel.isThinking {
                    ThinkingView()
                        .transition(.opacity)
                }
                
                ForEach(viewModel.dataSource.reversed()) { message in
                    ChatMessageView(model: message)
                        .matchedGeometryEffect(id: message.id, in: insight)
                        .onAppear {
                            if viewModel.dataSource.last == message {
                                viewModel.loadNext()
                            }
                        }
                }
                .font(Font.system(size: 17.scale))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.leading)
                .rotationEffect(.degrees(180))
                
                if viewModel.isMessagesLoading {
                    ProgressView()
                        .progressViewStyle(.spinner)
                        .transition(.opacity)
                }
            }
        }
        .rotationEffect(.degrees(180))
        .contentMargins(24.scale, for: .scrollContent)
    }
    
    @ViewBuilder
    private func tipsContent(for source: ChatTipsSource) -> some View {
        VStack(spacing: 0) {
            ChatMessageView(model: source.insight)
                .matchedGeometryEffect(id: source.insight.id, in: insight)
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

#Preview {
    NavigationStack {
        ChatViewScreen(model: .open(threadID: ""))
    }
}

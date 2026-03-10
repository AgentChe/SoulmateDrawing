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
    init(threadID: String) {
        _viewModel = State(initialValue: .init(threadID: threadID))
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                    
                    
                    ForEach(viewModel.dataSource) { message in
                        switch message.role {
                        case .user:
                            HStack {
                                Spacer(minLength: 72.scale)
                                Text(message.content)
                                    .padding(.horizontal, 20.scale)
                                    .padding(.vertical, 16.scale)
                                    .background(.bgMain400, in: RoundedRectangle(cornerRadius: 32.scale))
                            }
                            .transition(.opacity)
                        case .assistant:
                            HStack {
                                Text(message.content)
                                
                                Spacer(minLength: 46.scale)
                            }
                            .transition(.opacity)
                        }
                    }
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.leading)
                    .rotationEffect(.degrees(180))
                    
                    if viewModel.hasNext {
                        ProgressView()
                            .progressViewStyle(.spinner)
                            .onAppear {
                                viewModel.loadNext()
                            }
                    }
                }
            }
            .rotationEffect(.degrees(180))
            .contentMargins(24.scale, for: .scrollContent)
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
            HStack {
                TextField(text: $viewModel.currentText, axis: .vertical) {
                    Text("Chat.Placeholder".localized)
                        .foregroundStyle(.textMain200.opacity(0.6))
                        .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                       
                }
                .foregroundStyle(.textMain200)
                
                if !viewModel.currentText.isEmpty {
                    Button(
                        action: {
                            withAnimation {
                                viewModel.sendMessage()
                            }
                        },
                        label: {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 32.scale, height: 32.scale)
                        }
                    )
                    .symbolVariant(.circle.fill)
                    .foregroundStyle(.textMain100, .accentMain100)
                    .disabled(viewModel.isThinking)
                }
            }
            .padding(.vertical, 16.scale)
            .padding(.horizontal, 24.scale)
            .background(.bgMain300, in: RoundedRectangle(cornerRadius: 32.scale))
            .padding(.horizontal, 24.scale)
            .padding(.bottom, 16.scale)
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
        ChatViewScreen(threadID: "")
    }
}

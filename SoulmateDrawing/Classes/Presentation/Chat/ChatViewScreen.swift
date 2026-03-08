//
//  ChatViewScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import SwiftUI

struct WaveLoader: View {
    @State private var animating = false
    let numberOfDots = 3
    let dotSize: CGFloat = 4
    let spacing: CGFloat = 4

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfDots, id: \.self) { index in
                Circle()
                    .fill(.bgMain300)
                    .frame(width: 10)
                    .offset(y: animating ? 4 : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.3), // Staggered delay for wave effect
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

struct ChatViewScreen: View {
    @State private var viewModel: ChatScreenViewModel
    @State private var isPresentDeleteAlert = false
    init(threadID: String) {
        _viewModel = State(initialValue: .init(threadID: threadID))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    if !viewModel.isShowRetry {
                        VStack(spacing: 12) {
                            Button(action: viewModel.retryMessageAction) {
                                Text("Chat.RetryButton".localized)
                                    .font(Font.SFPro.font(size: 17, weight: .w510))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                            }
                            .foregroundStyle(.textMain200)
                            .background(.bgMain300)
                            .clipShape(Capsule())
                            
                            Text("Chat.RetryMessage".localized)
                                .font(Font.SFPro.font(size: 15, weight: .w400))
                                .foregroundStyle(.textMain200.opacity(0.6))
                        }
                        .padding(.top, 40)
                        .rotationEffect(.degrees(180))
                    }
                    
                    if viewModel.isThinking {
                        HStack {
                            Spacer()
                            WaveLoader()
                        }
                        .transition(.opacity)
                    }
                    
                    
                    ForEach(viewModel.dataSource) { message in
                        switch message.role {
                        case .user:
                            HStack {
                                Spacer(minLength: 72)
                                Text(message.content)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.bgMain400, in: RoundedRectangle(cornerRadius: 32))
                            }
                            .transition(.opacity)
                        case .assistant:
                            HStack {
                                Text(message.content)
                                
                                Spacer(minLength: 46)
                            }
                            .transition(.opacity)
                        }
                        
                    }
                    .font(Font.SFPro.font(size: 17, weight: .w400))
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
            .contentMargins(24, for: .scrollContent)
        }
        .scrollDismissesKeyboard(.immediately)
        .animation(.easeInOut, value: viewModel.dataSource)
        .frame(maxWidth: .infinity)
        .customBackButton()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    Text("MargoMargoMargoMargo")
                        .font(Font.Gambarino.font(size: 22, weight: .w400))
                    Text(ConnectionType.friend.title)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.bgMain300, in: Capsule())
                        .font(Font.SFPro.font(size: 17, weight: .w510))
                }
                .foregroundStyle(.textMain200)
            }
            
            ToolbarButton(placement: .topBarTrailing) {
                Menu(
                    content: {
                        Button(
                            role: .destructive,
                            action: { isPresentDeleteAlert = true},
                            label: {
                                Label("Chat.DeleteTitle".localized, systemImage: "trash")
                            }
                        )
//                        .foregroundStyle(Color(red: 1, green: 56/255, blue: 60/255))
                            
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
        .appBackground()
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField(text: $viewModel.currentText, axis: .vertical) {
                    Text("Chat.Placeholder".localized)
                        .foregroundStyle(.textMain200.opacity(0.6))
                        .font(Font.SFPro.font(size: 17, weight: .w400))
                       
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
                                .frame(width: 32, height: 32)
                        }
                    )
                    .symbolVariant(.circle.fill)
                    .foregroundStyle(.textMain100, .accentMain100)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(.bgMain300, in: RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
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

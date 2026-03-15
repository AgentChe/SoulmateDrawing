//
//  ChatScreenViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 01.03.2026.
//

import Foundation

struct ChatTipsSource {
    let insight: ChatMessageModel
    let tips: [ChatMessageModel]
}

@Observable
final class ChatScreenViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var dataSource: [ChatMessageModel] = []
    private(set) var isThinking = false
    private(set) var isShowRetry = false
    private(set) var hasNext = false
    private(set) var isShowSkeleton = false
    private(set) var isMessagesLoading = false
    
    var tipsDataSource: ChatTipsSource?
    var currentText: String = ""
    
    @ObservationIgnored
    private let chatManager = ChatManager()
    
    @ObservationIgnored
    private let threadID: String
    @ObservationIgnored
    private var page: Pagination?
    @ObservationIgnored
    private var message: String = ""
    
    private let initialModel: ChatInitialModel
    
    init(initialModel: ChatInitialModel) {
        self.initialModel = initialModel
        switch initialModel {
        case .open(let threadID):
            self.threadID = threadID
        case .start(let threadID, let insight, let tips):
            self.threadID = threadID
            let insightMessage = ChatMessageModel(id: UUID().uuidString, content: insight, role: .assistant)
            dataSource = [insightMessage]
            tipsDataSource = ChatTipsSource(
                insight: insightMessage,
                tips: tips.map { ChatMessageModel(id: UUID().uuidString, content: $0, role: .user) }
            )
        }
    }
    
    func load() {
        guard case .open = initialModel else { return }
        Task {
            await MainActor.run {
                isShowSkeleton = true
            }
            await loadMessages()
        }
    }
    
    func loadMessages() async {
        do {
            await MainActor.run {
                isMessagesLoading = true
            }
            let messages = try await chatManager.getMessages(for: threadID, page: page?.next)
            let dataSource = messages.items.map(ChatMessageModel.init).reversed()
            
            await MainActor.run {
                page = messages.pagination
                hasNext = messages.pagination.current < messages.pagination.next
                self.dataSource.append(contentsOf: dataSource)
                isMessagesLoading = false
                isShowSkeleton = false
            }
        } catch {
            await MainActor.run {
                hasNext = page.map { $0.current < $0.next } ?? false
                isMessagesLoading = false
                isShowSkeleton = false
            }
        }
    }
    
    func loadNext() {
        guard let page, !isMessagesLoading else { return }
        guard page.current < page.next else { return }
        Task {
            await MainActor.run {
                isMessagesLoading = true
            }
            await loadMessages()
        }
    }
    
    func sendMessage() {
        Task {
            let messageID = UUID().uuidString
            message = currentText
            guard !message.isEmpty else { return }
            await MainActor.run {
                dataSource.append(.init(id: messageID, content: message, role: .user))
                currentText = ""
                isThinking = true
            }
            
            do {
                let response = try await chatManager.sendMessage(message: message, threadID: threadID)
                let index = dataSource.firstIndex(where: { $0.id == messageID })
                
                await MainActor.run {
                    message = ""
                    if let index {
                        dataSource[index] = .init(item: response.user)
                        dataSource.append(.init(item: response.assistant))
                        isThinking = false
                    }
                }
            } catch {
                await MainActor.run {
                    isShowRetry = true
                    isThinking = false
                }
            }
        }
    }
    
    func retryMessageAction() {
        sendMessage()
    }
    
    func deleteChat() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                try await chatManager.chatDelete(threadID: threadID)
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
    
    private func startDataSource(insight: String, tips: [String]) {
        
    }
}

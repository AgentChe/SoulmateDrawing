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
    private(set) var isShowSkeleton = false
    private(set) var isMessagesLoading = false
    var scrollPosition: String?
    
    let personName: String
    let personType: ConnectionType
    
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
    @ObservationIgnored
    private var messageID: String = ""
    
    private let model: ChatModel
    
    private let coordinator: BondsCoordinator
    
    init(model: ChatModel, coordinator: BondsCoordinator) {
        self.model = model
        self.coordinator = coordinator
        self.personName = model.personName
        self.personType = model.personType
        self.threadID = model.threadID
        
        if let initialModel = model.tips {
            let insightMessage = ChatMessageModel(
                id: UUID().uuidString,
                content: initialModel.insight,
                role: .assistant
            )
            dataSource = [insightMessage]
            
            tipsDataSource = ChatTipsSource(
                insight: insightMessage,
                tips: initialModel.tips.map {
                    ChatMessageModel(id: UUID().uuidString, content: $0, role: .user)
                }
            )
        } else {
            load()
        }
    }
    
    private func load() {
        Task {
            do {
                try await initialLoad()
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.load()
                    }
                }
            }
        }
    }
    
    private func initialLoad() async throws {
        await MainActor.run {
            isShowSkeleton = true
            screenState = .loaded
        }
        let response = try await chatManager.getMessages(for: threadID, page: nil)
        let dataSource = response.items.reversed().map(ChatMessageModel.init)
        await MainActor.run {
            page = response.pagination
            self.dataSource = dataSource
            scrollPosition = dataSource.last?.id
            isShowSkeleton = false
        }
    }
    
    func loadNext() {
        guard let page, !isMessagesLoading else { return }
        guard page.current < page.next else { return }
        let currentPosition = scrollPosition
        Task {
            await MainActor.run {
                isMessagesLoading = true
            }
            do {
                let messages = try await chatManager.getMessages(for: threadID, page: page.next)
                let newMessages = messages.items.reversed().map(ChatMessageModel.init)
                
                await MainActor.run {
                    self.page = messages.pagination
                    self.dataSource = newMessages + dataSource
                    scrollPosition = currentPosition
                    isMessagesLoading = false
                }
            } catch {
                await MainActor.run {
                    isMessagesLoading = false
                }
            }
        }
    }
    
    func sendMessage() {
        Task {
            messageID = UUID().uuidString
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
                    messageID = ""
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
        guard !message.isEmpty, !messageID.isEmpty else { return }
        
        Task {
            await MainActor.run {
                isThinking = true
                isShowRetry = false
            }
            do {
                let response = try await chatManager.sendMessage(message: message, threadID: threadID)
                let index = dataSource.firstIndex(where: { $0.id == messageID })
                
                await MainActor.run {
                    message = ""
                    messageID = ""
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
    
    func deleteChat() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                try await chatManager.chatDelete(threadID: threadID)
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.deleteChat()
                    }
                }
            }
        }
    }
    
    func showDeleteAlert() {
        coordinator.showDeleteAlert { [weak self] in
            self?.deleteChat()
        }
    }
}

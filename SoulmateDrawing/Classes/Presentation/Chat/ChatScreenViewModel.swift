//
//  ChatScreenViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 01.03.2026.
//

import Foundation

enum RetryType {
    case sendMessage(message: String, localMessageID: String)
    case runner(runID: String)
}

@Observable
final class ChatScreenViewModel {
    
    private(set) var dataSource: [ChatMessageModel] = []
    private(set) var isThinking = false
    private(set) var isShowRetry = false
    private(set) var hasNext = false
    var currentText: String = "sdlgkjh sdh sjdkgh u bsuvg u sg sdf jjkn"
    
    @ObservationIgnored
    private let chatManager = ChatManager()
    
    @ObservationIgnored
    private var isMessagesLoading = false
    
    @ObservationIgnored
    private let threadID: String
    @ObservationIgnored
    private var page: Pagination?
    
    @ObservationIgnored
    private var runnerTask: Task<Void, Error>?
    
    private(set) var retryAction: RetryType?

    private let (stream, continuation) = AsyncStream.makeStream(of: RetryType.self)
    
    init(threadID: String) {
        self.threadID = threadID
        load()
    }
    
    deinit {
        continuation.finish()
    }
    
    func load() {
        Task {
            await loadMessages()
        }
        
        Task {
            for await action in stream {
                switch action {
                case .sendMessage(let message, let localMessageID):
                    await sendMessageRequest(message: message, localMessageID: localMessageID)
                case .runner(let runID):
                    await checkRunner(runID: runID)
                }
            }
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
                page = messages.pagingation
                hasNext = messages.pagingation.current < messages.pagingation.next
                self.dataSource.append(contentsOf: dataSource)
                isMessagesLoading = false
            }
        } catch {
            await MainActor.run {
                if let page {
                    hasNext = page.current < page.next
                } else {
                    hasNext = false
                }
                isMessagesLoading = false
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
            let message = currentText
            await MainActor.run {
                dataSource.insert(.init(id: messageID, content: message, role: .user), at: 0)
                currentText = ""
            }
            
            continuation.yield(.sendMessage(message: message, localMessageID: messageID))
        }
    }
    
    private func sendMessageRequest(message: String, localMessageID: String) async {
        await MainActor.run {
            isThinking = true
            isShowRetry = false
        }
        do {
            let sendResponse = try await chatManager.sendMessage(message: message, threadID: threadID)
            
            let index = dataSource.firstIndex(where: { $0.id == localMessageID })
            
            if let index {
                dataSource[index] = .init(item: sendResponse.user)
            }
            
            continuation.yield(.runner(runID: sendResponse.runner.runID))
        } catch {
            await MainActor.run {
                retryAction = .sendMessage(message: message, localMessageID: localMessageID)
                isShowRetry = true
                isThinking = false
            }
        }
    }
    
    private func checkRunner(runID: String) async {
        await MainActor.run {
            isThinking = true
            isShowRetry = false
        }
        runnerTask?.cancel()
        runnerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }
                do {
                    let runnerResult = try await chatManager.checkRunner(runID: runID, for: threadID)
                    if runnerResult.isComplete, let message = runnerResult.content {
                        await MainActor.run {
                            dataSource.insert(.init(item: message), at: 0)
                            isThinking = false
                            isShowRetry = false
                        }
                        return
                    }
                } catch {
                    await MainActor.run {
                        retryAction = .runner(runID: runID)
                        isShowRetry = true
                        isThinking = false
                    }
                }
            }
        }
    }
    
    func retryMessageAction() {
        if let retryAction {
            continuation.yield(retryAction)
        }
    }
    
    func deleteChat() {
        Task {
            do {
                try await chatManager.chatDelete(threadID: threadID)
            } catch {
                
            }
        }
    }
}

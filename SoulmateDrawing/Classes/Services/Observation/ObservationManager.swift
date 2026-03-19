//
//  ObservationManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation

final class ObservationManager {
    static let shared = ObservationManager()
    
    private let (settingsStream, settingsContinuation) = AsyncStream<Void>.makeStream()
    private let (chatStream, chatContinuation) = AsyncStream<Void>.makeStream()
    
    
    private init() {}
    
    func settingsDidUpdated() {
        settingsContinuation.yield(())
    }
    
    func chatListDidUpdated() {
        chatContinuation.yield(())
    }
    
    var settingsUpdated: AsyncStream<Void> { settingsStream }
    var chatsUpdated: AsyncStream<Void> { chatStream }
}

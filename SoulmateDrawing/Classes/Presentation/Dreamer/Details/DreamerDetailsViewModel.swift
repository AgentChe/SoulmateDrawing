//
//  DreamerDetailsViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.03.2026.
//

import Foundation

enum DreamerDetailsType: Hashable {
    case load(id: String)
    case interpret(dream: String)
}

@Observable
final class DreamerDetailsViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var isLoading = true
    private(set) var model: DreamDetailsModel?
    
    private let type: DreamerDetailsType
    
    @ObservationIgnored
    private let dreamManager = DreamerManager()
    
    init(type: DreamerDetailsType) {
        self.type = type
        load()
    }
    
    func load() {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            let result: DreamDetailsModel
            
            do {
                switch type {
                case .load(let id):
                    result = try await loadDreamDetails(for: id)
                case .interpret(let dream):
                    result = try await interpretaion(dream: dream)
                }
                
                await MainActor.run {
                    model = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    screenState = .error
                }
            }
        }
    }
    
    private func loadDreamDetails(for id: String) async throws -> DreamDetailsModel {
        let response = try await dreamManager.dreamDetails(dreamID: id)
        
        return DreamDetailsModel(image: response.image, text: response.text)
    }
    
    private func interpretaion(dream text: String) async throws -> DreamDetailsModel {
        let response = try await dreamManager.interpretation(dream: text)
        
        return DreamDetailsModel(image: response.image, text: response.text)
    }
}

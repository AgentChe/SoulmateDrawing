//
//  SoulmateDrawingResultViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

@Observable
final class SoulmateDrawingResultViewModel {
    private(set) var screenState: ScreenState = .loading
    private(set) var mainPoints: [MainPoint] = []
    private(set) var imageURL: URL? = nil
    private(set) var charts: [Chart] = []
    private(set) var exploreItems: [ExploreItem] = []
    private(set) var exploreTitle: String = ""
    
    @ObservationIgnored
    private let soulmateManager = SoulmateManager()
    
    init() { load() }
    
    func load() {
        Task {
            do {
                let soulmate = try await soulmateManager.soulmate()
                
                await MainActor.run {
                    mainPoints = soulmate.mainPoints
                    imageURL = soulmate.image
                    charts = soulmate.charts
                    exploreTitle = soulmate.explore.tip
                    exploreItems = soulmate.explore.items
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
}

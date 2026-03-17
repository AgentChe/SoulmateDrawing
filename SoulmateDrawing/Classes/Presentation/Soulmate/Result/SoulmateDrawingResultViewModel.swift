//
//  SoulmateDrawingResultViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

@Observable
final class SoulmateDrawingResultViewModel {
    let mainPoints: [MainPoint]
    let imageURL: URL?
    let charts: [Chart]
    let exploreItems: [ExploreItem]
    let exploreTitle: String
    
    var selectedSegment = SoulmateSegmentItem.explore
    
    var hasActiveSubscription: Bool {
        return sessionManager.hasActiveSubscriptions()
    }
    
    @ObservationIgnored
    private let soulmate: SoulmateModel
    @ObservationIgnored
    private let sessionManager = SessionManager()
    
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, soulmate: SoulmateModel) {
        self.soulmate = soulmate
        self.coordinator = coordinator
        mainPoints = soulmate.mainPoints
        imageURL = soulmate.image
        charts = soulmate.explore.charts
        exploreTitle = soulmate.explore.tip
        exploreItems = soulmate.explore.items
    }
    
    func startOver() {
        coordinator.startOver()
    }
    
    func showPaygate() {
        coordinator.showPaygate()
    }
    
    func openDetails(item: ExploreItem) {
        coordinator.openExploreCard(item)
    }
}

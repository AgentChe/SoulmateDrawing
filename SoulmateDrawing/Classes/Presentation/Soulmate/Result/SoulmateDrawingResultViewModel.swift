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
    
    init(soulmate: SoulmateModel) {
        self.soulmate = soulmate
        mainPoints = soulmate.mainPoints
        imageURL = soulmate.image
        charts = soulmate.explore.charts
        exploreTitle = soulmate.explore.tip
        exploreItems = soulmate.explore.items
    }
}

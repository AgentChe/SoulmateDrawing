//
//  SoulmateDrawingResultViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation
import UIKit
import SwiftUI

@Observable
final class SoulmateDrawingResultViewModel {
    let mainPoints: [MainPoint]
    let imageURL: URL?
    let charts: [Chart]
    let exploreItems: [ExploreItem]
    let exploreTitle: String
    var selectedSegment = SoulmateSegmentItem.explore
    private(set) var isLoading = false
    
    private(set) var hasActiveSubscription: Bool
    
    @ObservationIgnored
    private let soulmate: SoulmateModel
    @ObservationIgnored
    private let sessionManager = SessionManager()
    
    private let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, soulmate: SoulmateModel) {
        self.soulmate = soulmate
        self.coordinator = coordinator
        mainPoints = soulmate.mainPoints
        imageURL = soulmate.image
        charts = soulmate.explore.charts
        exploreTitle = soulmate.explore.tip
        exploreItems = soulmate.explore.items
        hasActiveSubscription = sessionManager.hasActiveSubscriptions()
    }
    
    func testShare(scale: CGFloat) {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            let content = await SoulmateSnapshotContent(imageURL: imageURL, mainPoints: mainPoints)
            let view = SoulmateShareView(content: content)
            let renderer = ImageRenderer(content: view)
            renderer.scale = scale
            
            
            await MainActor.run {
                isLoading = false
                if let image = renderer.uiImage {
                    share(image: image)
                }
            }
        }
    }
}

@MainActor
extension SoulmateDrawingResultViewModel {
    func startOver() {
        coordinator.startOver()
    }
    
    func showPaygate() {
        coordinator.showPaygate()
    }
    
    func openDetails(item: ExploreItem) {
        coordinator.openExploreCard(item)
    }
    
    func share(image: UIImage) {
        coordinator.shareSoulmate(image: image)
    }
    
    func checkActiveSubscription() {
        hasActiveSubscription = sessionManager.hasActiveSubscriptions()
    }
}

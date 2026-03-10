//
//  NavigationManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.01.2026.
//

import Foundation
import SwiftUI

enum MainRoute: Hashable, Identifiable {
    case soulmateCheckProfile
    case insightsList([InsightModel])
    case exploreDetails(ExploreItem)
    case soulmateResult(SoulmateModel)
    case chat(threadID: String)
    case soulmateOnboarding
    case dreamerDetails(type: DreamerDetailsType)
    case dreamerHistory
    
    var id: String {
        switch self {
        case .soulmateCheckProfile:
            return "soulmateCheckProfile"
        case .insightsList:
            return "insightsList"
        case .exploreDetails:
            return "exploreDetails"
        case .soulmateResult(let result):
            return "soulmateResult_\(result.explore.items.map(\.title))"
        case .chat(let threadID):
            return threadID
        case .soulmateOnboarding:
            return "soulmateOnboarding"
        case .dreamerDetails(let type):
            return "dreamerDetails_\(type.hashValue)"
        case .dreamerHistory:
            return "dreamerHistory"
        }
    }
}

@Observable @MainActor
final class NavigationManager {
    static let shared = NavigationManager()
    var path: [MainRoute] = []
    var selectedTab: TabElement = .home
    var fullScreenCover: MainRoute?
    
    func push(_ route: MainRoute) {
        path.append(route)
    }
    
    func selectTab(_ tab: TabElement) {
        selectedTab = tab
    }
    
    func pop() {
        path.removeLast()
    }
    
    func fullScreen(_ route: MainRoute) {
        fullScreenCover = route
    }
}

extension EnvironmentValues {
    @Entry var navigation = NavigationManager.shared
}

struct RootNavigationStack<Content: View>: View {
    @Bindable private var router: NavigationManager
    private let content: Content
    
    init(router: NavigationManager, @ViewBuilder _ root: () -> Content) {
        self.router = router
        content = root()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: MainRoute.self) { route in
                    destination(for: route)
                }
                .fullScreenCover(item: $router.fullScreenCover) { route in
                    NavigationStack {
                        destination(for: route)
                    }
                }
        }
        .environment(\.navigation, router)
    }
    
    @ViewBuilder
    private func destination(for route: MainRoute) -> some View {
        switch route {
        case .soulmateCheckProfile:
            SoulmateCheckProfile()
        case let .insightsList(items):
            InsightsListView(models: items)
        case let .exploreDetails(item):
            ExploreCardDetailView(item: item)
        case let .soulmateResult(soulmate):
            SoulmateDrawingResultView(soulmate: soulmate)
        case .soulmateOnboarding:
            SoulmateOnboarding()
        case let .chat(threadID):
            ChatViewScreen(threadID: threadID)
        case let .dreamerDetails(type):
            DreamerDetailsScreenView(type: type)
        case .dreamerHistory:
            DreamerHistoryScreenView()
        }
    }
}

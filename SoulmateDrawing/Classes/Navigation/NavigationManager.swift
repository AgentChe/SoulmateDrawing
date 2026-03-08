//
//  NavigationManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.01.2026.
//

import Foundation
import SwiftUI

enum MainRoute: Hashable {
    case settings
    case paygate
    case soulmateCheckProfile
    case insightsList([InsightModel])
    case exploreDetails(ExploreItem)
    case soulmateResult(SoulmateModel)
    case chat(threadID: String)
    case soulmateOnboarding
    case dreamerDetails(type: DreamerDetailsType)
    case dreamerHistory
}

@Observable @MainActor
final class NavigationManager {
    static let shared = NavigationManager()
    var path: [MainRoute] = []
    var isPesentedFullscreen = false
    var isPresentedSheet = false
    var selectedTab: TabElement = .home
    
    @ObservationIgnored
    var fullScreenCover: MainRoute?
    @ObservationIgnored
    var sheet: MainRoute?
    
    func push(_ route: MainRoute) {
        path.append(route)
    }
    
    func selectTab(_ tab: TabElement) {
        selectedTab = tab
    }
    
    func pop() {
        path.removeLast()
    }
    
    func dismissFullScreen() {
        isPesentedFullscreen = false
        fullScreenCover = nil
    }
    
    func fullScreen(_ route: MainRoute) {
        if isPesentedFullscreen {
            dismissFullScreen()
        }
        fullScreenCover = route
        isPesentedFullscreen = true
    }
    
    func dismissSheet() {
        isPresentedSheet = false
        sheet = nil
    }
    
    func sheet(_ route: MainRoute) {
        if isPresentedSheet {
            dismissSheet()
        }
        
        sheet = route
        isPresentedSheet = true
    }
}

extension EnvironmentValues {
    @Entry var navigation = NavigationManager.shared
}

struct RootNavigationStack<Content: View>: View {
    @Bindable private var router = NavigationManager.shared
    private let content: Content
    
    init(@ViewBuilder _ root: () -> Content) {
        content = root()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: MainRoute.self) { route in
                    destination(for: route)
                }
                .fullScreenCover(
                    isPresented: $router.isPesentedFullscreen,
                    onDismiss: router.dismissFullScreen,
                    content: {
                        NavigationStack {
                            destination(for: router.fullScreenCover)
                        }
                    }
                )
                .sheet(isPresented: $router.isPresentedSheet, onDismiss: router.dismissSheet) {
                    NavigationStack {
                        destination(for: router.sheet)
                    }
                }

        }
        .environment(\.navigation, router)
    }
    
    @ViewBuilder
    private func destination(for route: MainRoute?) -> some View {
        switch route {
        case .settings:
            SettingsView()
        case .paygate:
            PaygateView()
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
        case .none:
            Color.white
        }
    }
}

struct TabBarView<Content: View>: View {
    @Binding private var selected: TabElement
    @ViewBuilder
    private var content: (TabElement) -> Content
    private let items: [TabElement]
    
    init(items: [TabElement], selected: Binding<TabElement>, @ViewBuilder content: @escaping (TabElement) -> Content) {
        self.content = content
        self.items = items
        self._selected = selected
    }
    
    var body: some View {
        TabView(selection: $selected) {
            ForEach(items) { tab in
                RootNavigationStack {
                    switch tab {
                    case .home:
                        HomeView()
                    case .dreamer:
                        DreamerMainScreen()
                    case .bonds:
                        BondsView()
                    }
                }
                .tabItem {
                    Image(tab.iconName)
                    Text(tab.title)
                }
            }
        }
//        ZStack {
//            ForEach(items) { tab in
//                switch tab {
//                case .home:
//                    HomeView()
//                        .opacity(selected == .home ? 1 : 0)
//                case .dreamer:
//                    DreamerMainScreen()
//                        .opacity(selected == .dreamer ? 1 : 0)
//                case .bonds:
//                    BondsView()
//                        .opacity(selected == .bonds ? 1 : 0)
//                }
//            }
//        }
//        .safeAreaInset(edge: .bottom, spacing: 0) {
//            tabBar
//        }
//        .toolbar {
//            if selected == .home {
//                ToolbarButton(placement: .topBarLeading) {
//                    Button(
//                        action: {
////                            viewModel.showSettings()
//    //                            coordinator.sheet(.settings)
//                        },
//                        label: { Image("settings") }
//                    )
//                    .buttonStyle(.navigation)
//                }
//                
//                ToolbarButton(placement: .topBarTrailing) {
//                    ProButton {
////                        viewModel.showPaygate()
//                    }
//                }
//            }
//            
//            if selected == .dreamer {
//                ToolbarButton(placement: .topBarTrailing) {
//                    Button(
//                        action: { },
//                        label: { Image(systemName: "line.3.horizontal") }
//                    )
//                    .buttonStyle(.navigation)
//                }
//                
//                ToolbarItem(placement: .principal) {
//                    Text("Dreamer.Title".localized)
//                        .font(Font.Gambarino.font(size: 22, weight: .w400))
//                        .foregroundStyle(.textMain200)
//                }
//            }
//        }
    }
    
    @ViewBuilder
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button(
                    action: {
                        withAnimation {
                            selected = item
                        }
                    },
                    label: {
                        VStack(spacing: 2) {
                            Image(item.iconName)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(item.title)
                        }
                        .foregroundStyle(selected == item ? .textMain200 : .textMain200.opacity(0.4))
                    }
                )
                .frame(width: 60, height: 75)
                if item != items.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 40)
        .font(Font.SFPro.font(size: 12, weight: .w510))
        .background(.bgMain100)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(red: 144/255, green: 115/255, blue: 95/255, opacity: 0.1))
                .frame(height: 1)
        }
    }
}

//protocol Routable: View, Hashable, Identifiable {
//}
//protocol TabRoutable: Routable {
//    var iconName: String { get }
//    var title: String { get }
//}
//
//protocol Coordinatable: Observable {
//    associatedtype Route: Routable
//    func push(_ route: Route)
//    func sheet(_ route: Route)
//    func fullScreen(_ route: Route)
//}
//
//@Observable @MainActor
//class Coordinator<Route>: Coordinatable where Route: Routable {
//    var path: NavigationPath = .init()
//    var sheet: Route?
//    var fullScreenCover: Route?
//
//
//    func push(_ route: Route) {
//        path.append(route)
//    }
//
//    func sheet(_ route: Route) {
//        sheet = route
//    }
//
//    func fullScreen(_ route: Route) {
//        fullScreenCover = route
//    }
//}
//
//struct CoordinatorStack<Route: Routable>: View {
//    @State private var coordinator = Coordinator<Route>()
//    private let root: Route
//
//    init(root: Route) {
//        self.root = root
//    }
//
//    var body: some View {
//        NavigationStack(path: $coordinator.path) {
//            root
//                .navigationDestination(for: Route.self) { $0 }
//                .sheet(item: $coordinator.sheet) { $0 }
//                .fullScreenCover(item: $coordinator.fullScreenCover) { $0}
//        }
//        .environment(coordinator)
//    }
//}
//
//@Observable @MainActor
//class TabCoordinator<TabRoute: TabRoutable> {
//    var current: TabRoute?
//
//    @ObservationIgnored
//    var tabs: [TabRoute]
//
//    init(tabs: [TabRoute]) {
//        self.current = tabs.first
//        self.tabs = tabs
//    }
//}
//
//struct TabCoordinatorStack<TabRoute: TabRoutable>: View {
//    @State private var coordinator: TabCoordinator<TabRoute>
//
//    init(tabs: [TabRoute]) {
//        self._coordinator = .init(initialValue: .init(tabs: tabs))
//    }
//
//    var body: some View {
//        TabView(selection: $coordinator.current) {
//            ForEach(coordinator.tabs) { tab in
//                tab
//                    .tabItem {
//                        VStack(spacing: 2) {
//                            Image(tab.iconName)
//                            Text(tab.title)
//                        }
//                        .foregroundStyle(coordinator.current == tab ? .textMain200 : .textMain200.opacity(0.4))
//                    }
//            }
//        }
//    }
//}

//enum TabItem: TabRoutable, CaseIterable {
//    case home
//    case dreamer
//    case bonds
//    
//    var id: Self { self }
//    
//    var iconName: String {
//        switch self {
//        case .home:
//            "home"
//        case .dreamer:
//            "dreamer"
//        case .bonds:
//            "bonds"
//        }
//    }
//    
//    var title: String {
//        switch self {
//        case .home:
//            "Home".localized
//        case .dreamer:
//            "Dreamer".localized
//        case .bonds:
//            "Bonds"
//            .localized
//        }
//    }
//    
//    var body: some View {
//        switch self {
//        case .home:
//            CoordinatorStack1(root: HomeRoute1.main)
//        case .dreamer:
//            Color.red
//        case .bonds:
//            CoordinatorStack1(root: BondsRoute.main)
//        }
//    }
//}
//
//enum HomeRoute1: Routable1 {
//    case main
//    case settings
//    case paygate
//    
//    var id: UUID { .init() }
//    
//    @ViewBuilder
//    func body(use coordinator: Coordinator1<HomeRoute1>) -> some View {
//        switch self {
//        case .main:
//            HomeView(coordinator: coordinator)
//        case .settings:
//            CoordinatorStack1(root: SettingsRoute.main)
//        case .paygate:
//            PaygateView()
//        }
//    }
//}
//
//enum SettingsRoute: Routable1 {
//    case main
//    case dateOfBird(current: Date, selected: (Date) -> Void)
//    case placeOfBird(current: String, selected: (String) -> Void)
//    case timeOfBird(current: Date, selected: (Date) -> Void)
//    
//    var id: UUID { .init() }
//    
//    static func ==(lhs: Self, rhs: Self) -> Bool {
//        switch (lhs, rhs) {
//        case (.main, .main), (.dateOfBird, .dateOfBird), (.placeOfBird, .placeOfBird), (.timeOfBird, .timeOfBird):
//            return true
//        default:
//            return false
//        }
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .main:
//            hasher.combine("main")
//        case .dateOfBird(let current, _):
//            hasher.combine(current)
//            hasher.combine("dateOfBird")
//        case .placeOfBird(let current, _):
//            hasher.combine(current)
//            hasher.combine("placeOfBird")
//        case .timeOfBird(let current, _):
//            hasher.combine(current)
//            hasher.combine("timeOfBird")
//        }
//    }
//    
//    @ViewBuilder
//    func body(use coordinator: Coordinator1<SettingsRoute>) -> some View {
//        switch self {
//        case .main:
//            SettingsView(coordinator: coordinator)
//        case .dateOfBird(let current, let selected):
//            OnboardingBornDate(bornDate: current, didTapContinue: selected)
//        case .placeOfBird(let current, let selected):
//            OnboardingCityView(city: current, didTapContinue: selected)
//        case .timeOfBird(let current, let selected):
//            OnboardingBornTime(bornTime: current, didTapContinue: selected)
//        }
//    }
//}
//
//@Observable @MainActor
//class Coordinator1<Route: Routable1> {
//    var path: NavigationPath = .init()
//    var sheet: Route?
//    var fullScreenCover: Route?
//    
//    
//    func push(_ route: Route) {
//        path.append(route)
//    }
//    
//    func sheet(_ route: Route) {
//        sheet = route
//    }
//    
//    func fullScreen(_ route: Route) {
//        fullScreenCover = route
//    }
//}
//
//protocol Routable1: Hashable, Identifiable {
//    associatedtype Content: View
//    func body(use coordinator: Coordinator1<Self>) -> Content
//}
//
//
//struct CoordinatorStack1<Route: Routable1>: View {
//    @State private var coordinator = Coordinator1<Route>()
//    private let root: Route
//    
//    init(root: Route) {
//        self.root = root
//    }
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.path) {
//            root.body(use: coordinator)
//                .navigationDestination(for: Route.self) { $0.body(use: coordinator) }
//                .sheet(item: $coordinator.sheet) { $0.body(use: coordinator) }
//                .fullScreenCover(item: $coordinator.fullScreenCover) { $0.body(use: coordinator) }
//        }
//    }
//}

//enum BondsRoute: Routable1 {
//    case main
//    case personList(persons: [PersonModel], selected: (PersonModel) -> Void)
//    case insightsList(models: [InsightModel])
//    case connectionType((ConnectionType) -> Void)
//    case newPerson(created: (PersonModel) -> Void)
//    
//    @ViewBuilder
//    func body(use coordinator: Coordinator1<Self>) -> some View {
//        switch self {
//        case .main:
//            BondsView(coordinator: coordinator)
//        case let .personList(persons, selected):
//            CoordinatorStack(root: SelectPersonRoute.main(persons: persons, selected: selected))
//        case let .insightsList(models):
//            InsightsListView(models: models)
//        case let .connectionType(selected):
//            ConnectionTypeView(selected: selected)
//        case .newPerson(let created):
//            CoordinatorStack(root: SelectPersonRoute.create(created: created))
//        }
//    }
//    
//    var id: UUID { .init() }
//    
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        switch (lhs, rhs) {
//        case (.main, .main), (.connectionType, .connectionType), (.newPerson, .newPerson):
//            return true
//        case (.personList(let lhsModel, _), .personList(let rhsModel, _)):
//            return lhsModel == rhsModel
//        case (.insightsList(let lhsModel), .insightsList(let rhsModel)):
//            return lhsModel == rhsModel
//        default:
//            return false
//        }
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .main:
//            hasher.combine("home_bounds_route")
//        case .personList(let persons, _):
//            hasher.combine("personList_bounds_route")
//            hasher.combine(persons.hashValue)
//        case .insightsList(let models):
//            hasher.combine("insightsList_bounds_route")
//            hasher.combine(models.hashValue)
//        case .connectionType:
//            hasher.combine("connectionType_bounds_route")
//        case .newPerson:
//            hasher.combine("newPerson_bounds_route")
//        }
//    }
//}
//
//enum SelectPersonRoute: Routable {
//    case main(persons: [PersonModel], selected: (PersonModel) -> Void)
//    case create(created: (PersonModel) -> Void)
//    
//    var id: UUID { .init() }
//    
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        switch (lhs, rhs) {
//        case (.main(let lhsModel, _), .main(let rhsModel, _)):
//            return lhsModel == rhsModel
//        case (.create, .create):
//            return true
//        default:
//            return false
//        }
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .main(let persons, _):
//            hasher.combine("main_select_person_route")
//            hasher.combine(persons.hashValue)
//        case .create:
//            hasher.combine("create_select_person_route")
//        }
//    }
//    
//    var body: some View {
//        switch self {
//        case .main(let persons, let selected):
//            PersonList(persons: persons, selected: selected)
//        case .create(let created):
//            NewPersonView(createdPerson: created)
//        }
//    }
//}
//
//struct TabCoordinatorStack1<TabRoute: TabRoutable>: View {
//    @State private var coordinator: TabCoordinator<TabRoute>
//    
//    init(tabs: [TabRoute]) {
//        self._coordinator = .init(initialValue: .init(tabs: tabs))
//    }
//    
//    var body: some View {
//        ZStack {
//            ForEach(coordinator.tabs) { tab in
//                tab
//                    .opacity(coordinator.current == tab ? 1 : 0)
//            }
//        }
//        .safeAreaInset(edge: .bottom) {
//            tabBar
//        }
//    }
//    
//    @ViewBuilder
//    private var tabBar: some View {
//        HStack(spacing: 0) {
//            ForEach(coordinator.tabs) { item in
//                Button(
//                    action: { coordinator.current = item },
//                    label: {
//                        VStack(spacing: 2) {
//                            Image(item.iconName)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                            Text(item.title)
//                        }
//                        .foregroundStyle(coordinator.current == item ? .textMain200 : .textMain200.opacity(0.4))
//                    }
//                )
//                .frame(width: 60, height: 75)
//                if item != coordinator.tabs.last {
//                    Spacer()
//                }
//            }
//        }
//        .padding(.horizontal, 40)
//        .font(Font.SFPro.font(size: 12, weight: .w510))
//        .background(.bgMain100)
//        .overlay(alignment: .top) {
//            Rectangle()
//                .fill(Color(red: 144/255, green: 115/255, blue: 95/255, opacity: 0.1))
//                .frame(height: 1)
//        }
//    }
//}

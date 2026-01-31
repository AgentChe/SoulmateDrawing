//
//  NavigationManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.01.2026.
//

import Foundation
import SwiftUI

protocol Routable: View, Hashable, Identifiable {}
protocol TabRoutable: Routable {
    var iconName: String { get }
    var title: String { get }
}

@Observable @MainActor
class Coordinator<Route: Routable> {
    var path: NavigationPath = .init()
    var sheet: Route?
    var fullScreenCover: Route?
    
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func sheet(_ route: Route) {
        sheet = route
    }
    
    func fullScreen(_ route: Route) {
        fullScreenCover = route
    }
}

protocol Coordinatable: Observable {
    associatedtype Route: Routable
    func push(_ route: Route)
    func sheet(_ route: Route)
    func fullScreen(_ route: Route)
}

struct CoordinatorStack<Route: Routable>: View {
    @State private var coordinator = Coordinator<Route>()
    private let root: Route
    
    init(root: Route) {
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: Route.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover) { $0}
        }
        .environment(coordinator)
    }
}

@Observable @MainActor
class TabCoordinator<TabRoute: TabRoutable> {
    var current: TabRoute?
    
    @ObservationIgnored
    var tabs: [TabRoute]
    
    init(tabs: [TabRoute]) {
        self.current = tabs.first
        self.tabs = tabs
    }
}

struct TabCoordinatorStack<TabRoute: TabRoutable>: View {
    @State private var coordinator: TabCoordinator<TabRoute>
    
    init(tabs: [TabRoute]) {
        self._coordinator = .init(initialValue: .init(tabs: tabs))
    }
    
    var body: some View {
        TabView(selection: $coordinator.current) {
            ForEach(coordinator.tabs) { tab in
                tab
                    .tabItem {
                        VStack(spacing: 2) {
                            Image(tab.iconName)
                            Text(tab.title)
                        }
                        .foregroundStyle(coordinator.current == tab ? .textMain200 : .textMain200.opacity(0.4))
                    }
            }
        }
    }
}


enum Route: Hashable {
    case settings
    case insightsList([InsightModel])
}

@Observable @MainActor
final class NavigationManager {
    static let shared = NavigationManager()
    var path: [Route] = []
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
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
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .settings:
                        Color.blue
                    case let .insightsList(items):
                        InsightsListView(models: items)
                    }
                }
        }
        .environment(\.navigation, router)
    }
}

enum TabItem: TabRoutable, CaseIterable {
    case home
    case dreamer
    case bonds
    
    var id: Self { self }
    
    var iconName: String {
        switch self {
        case .home:
            "home"
        case .dreamer:
            "dreamer"
        case .bonds:
            "bonds"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            "Home".localized
        case .dreamer:
            "Dreamer".localized
        case .bonds:
            "Bonds"
            .localized
        }
    }
    
    var body: some View {
        switch self {
        case .home:
            CoordinatorStack(root: HomeRoute.main)
        case .dreamer:
            Color.red
        case .bonds:
            CoordinatorStack(root: BondsRoute.main)
        }
    }
}

enum HomeRoute: Routable {
    case main
    case settings
    case paygate
    
    var id: Self { self }
    
    var body: some View {
        switch self {
        case .main:
            HomeView()
        case .settings:
            Color.purple
        case .paygate:
            PaygateView()
        }
    }
}

enum BondsRoute: Routable {
    case main
    case personList(persons: [PersonModel], selected: (PersonModel) -> Void)
    case insightsList(models: [InsightModel])
    case connectionType
    case newPerson(created: (PersonModel) -> Void)
    
    var id: String {
        switch self {
        case .main:
            "main"
        case .personList(let persons, _):
            persons.map(\.id).joined() + "bounds_route"
        case .insightsList(let models):
            models.map(\.id).joined()
        case .connectionType:
            "connectionType"
        case .newPerson:
            "newPerson"
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.main, .main), (.connectionType, .connectionType), (.newPerson, .newPerson):
            return true
        case (.personList(let lhsModel, _), .personList(let rhsModel, _)):
            return lhsModel == rhsModel
        case (.insightsList(let lhsModel), .insightsList(let rhsModel)):
            return lhsModel == rhsModel
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .main:
            hasher.combine("home_bounds_route")
        case .personList(let persons, _):
            hasher.combine("personList_bounds_route")
            hasher.combine(persons.hashValue)
        case .insightsList(let models):
            hasher.combine("insightsList_bounds_route")
            hasher.combine(models.hashValue)
        case .connectionType:
            hasher.combine("connectionType_bounds_route")
        case .newPerson:
            hasher.combine("newPerson_bounds_route")
        }
    }
    
    var body: some View {
        switch self {
        case .main:
            BondsView()
        case let .personList(persons, selected):
            CoordinatorStack(root: SelectPersonRoute.main(persons: persons, selected: selected))
        case let .insightsList(models):
            InsightsListView(models: models)
        case .connectionType:
            ConnectionTypeView { _ in }
        case .newPerson(let created):
            CoordinatorStack(root: SelectPersonRoute.create(created: created))
        }
    }
}

enum SelectPersonRoute: Routable {
    case main(persons: [PersonModel], selected: (PersonModel) -> Void)
    case create(created: (PersonModel) -> Void)
    
    var id: String {
        switch self {
        case .main(let persons, _):
            persons.map(\.id).joined() + "select_person_route"
        case .create:
            "create_select_person_route"
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.main(let lhsModel, _), .main(let rhsModel, _)):
            return lhsModel == rhsModel
        case (.create, .create):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .main(let persons, _):
            hasher.combine("main_select_person_route")
            hasher.combine(persons.hashValue)
        case .create:
            hasher.combine("create_select_person_route")
        }
    }
    
    var body: some View {
        switch self {
        case .main(let persons, let selected):
            PersonList(persons: persons, selected: selected)
        case .create(let created):
            NewPersonView(createdPerson: created)
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
        ZStack {
            ForEach(items) { tab in
                switch tab {
                case .home:
                    HomeView()
                        .opacity(selected == .home ? 1 : 0)
                case .dreamer:
                    Color.purple
                        .opacity(selected == .dreamer ? 1 : 0)
                case .bonds:
                    BondsView()
                        .opacity(selected == .bonds ? 1 : 0)
                }
            }
    }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
    }
    
    @ViewBuilder
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button(
                    action: { selected = item },
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

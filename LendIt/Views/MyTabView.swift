//
//  MyTabView.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MyTabFeature {
    @ObservableState
    struct State {
        var selectedTab: Tab = .home
        var home = HomeFeature.State()
        var items = ItemsFeature.State()
        var borrowers = BorrowersFeature.State()
    }

    enum Action {
        case tabChanged(Tab)
        case home(HomeFeature.Action)
        case items(ItemsFeature.Action)
        case borrowers(BorrowersFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.items, action: \.items) {
            ItemsFeature()
        }
        Scope(state: \.borrowers, action: \.borrowers) {
            BorrowersFeature()
        }

        Reduce { state, action in
            switch action {
            case let .tabChanged(tab):
                state.selectedTab = tab
                return .none
            case .home, .items, .borrowers:
                return .none
            }
        }
    }
}

enum Tab {
    case home, items, borrowers
}

struct MyTabView: View {
    @Bindable var store: StoreOf<MyTabFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabChanged)) {
            HomeView(
                store: self.store.scope(
                    state: \.home,
                    action: \.home
                )
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(Tab.home)
            ItemsView(
                store: self.store.scope(
                    state: \.items,
                    action: \.items
                )
            )
            .tabItem {
                Label("My items", systemImage: "books.vertical.fill")
            }
            .tag(Tab.items)
            BorrowersView(
                store: self.store.scope(
                    state: \.borrowers,
                    action: \.borrowers
                )
            )
            .tabItem {
                Label("Borrowers", systemImage: "person.2.fill")
            }
            .tag(Tab.borrowers)
        }
    }
}

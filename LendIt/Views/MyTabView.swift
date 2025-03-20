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
    }

    enum Action {
        case tabChanged(Tab)
        case home(HomeFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Reduce { state, action in
            switch action {
            case let .tabChanged(tab):
                state.selectedTab = tab
                return .none
            case .home:
                return .none
            }
        }
    }
}

enum Tab {
    case home, challenges, cohouse
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
        }
    }
}

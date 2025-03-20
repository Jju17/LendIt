//
//  AppView.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {

    @ObservableState
    enum State {
        case tab(MyTabFeature.State)
    }

    enum Action {
        case tab(MyTabFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tab:
                return .none
            }
        }
        .ifCaseLet(/State.tab, action: /Action.tab) {
            MyTabFeature()
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        Group {
            switch store.state {
            case .tab:
                if let rootStore = store.scope(state: \.tab, action: \.tab) {
                    MyTabView(store: rootStore)
                }
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State.tab(MyTabFeature.State())) {
            AppFeature()
        }
    )
}


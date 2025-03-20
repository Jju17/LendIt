//
//  LendForm.swift
//  colockitchenrace
//
//  Created by Julien Rahier on 09/10/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct LendItemFormFeature {

    @ObservableState
    struct State {
        var wipLendItem: Item
        var isNewCohouse: Bool = false
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}

struct LendItemFormView: View {
    @Bindable var store: StoreOf<LendItemFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Lended item name", text: $store.wipLendItem.name)
            }
        }
    }
}

#Preview {
    LendItemFormView(
        store: Store(initialState: LendItemFormFeature.State(wipLendItem: Item(id: UUID().uuidString, name: ""))) {
            LendItemFormFeature()
        })
}

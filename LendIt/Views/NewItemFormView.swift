//
//  NewItemForm.swift
//  colockitchenrace
//
//  Created by Julien Rahier on 09/10/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct NewItemFormFeature {
    @ObservableState
    struct State {
        var wipItem: Item
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

struct NewItemFormView: View {
    @Bindable var store: StoreOf<NewItemFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Item name", text: $store.wipItem.name)
            }
        }
    }
}

#Preview {
    NewItemFormView(
        store: Store(initialState: NewItemFormFeature.State(wipItem: Item(name: ""))) {
            NewItemFormFeature()
        })
}

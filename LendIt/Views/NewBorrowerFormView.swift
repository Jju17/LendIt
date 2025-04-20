//
//  NewBorrowerFormView.swift
//  LendIt
//
//  Created by Julien Rahier on 4/20/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct NewBorrowerFormFeature {
    @ObservableState
    struct State {
        var wipBorrower: Borrower
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

struct NewBorrowerFormView: View {
    @Bindable var store: StoreOf<NewBorrowerFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Borrower name", text: $store.wipBorrower.name, prompt: Text("John Doe"))
            }
        }
    }
}

#Preview {
    NewBorrowerFormView(
        store: Store(initialState: NewBorrowerFormFeature.State(wipBorrower: Borrower(name: ""))) {
            NewBorrowerFormFeature()
        })
}

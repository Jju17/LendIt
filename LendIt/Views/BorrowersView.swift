//
//  BorrowersView.swift
//  LendIt
//
//  Created by Julien Rahier on 4/20/25.
//

import ComposableArchitecture
import Sharing
import SwiftUI

@Reducer
struct BorrowersFeature {

    @Reducer
    enum Destination {
        case addBorrower(NewBorrowerFormFeature)
    }

    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared(.fileStorage(.borrowers)) var borrowers: [Borrower] = []
    }

    enum Action: BindableAction {
        case addBorrowerButtonTapped
        case binding(BindingAction<State>)
        case confirmAddBorrowerButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case dismissDestinationButtonTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .addBorrowerButtonTapped:
                state.destination = .addBorrower(
                    NewBorrowerFormFeature.State(
                        wipBorrower: Borrower(name: "")
                    )
                )
                return .none
            case .binding:
                return .none
            case .confirmAddBorrowerButtonTapped:
                guard case let .some(.addBorrower(newBorrowerFormFeature)) = state.destination
                else { return .none }

                let newBorrower = newBorrowerFormFeature.wipBorrower
                state.$borrowers.withLock {
                    $0.append(newBorrower)
                }
                state.destination = nil
                return .none
            case .destination:
              return .none
            case .dismissDestinationButtonTapped:
                state.destination = nil
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct BorrowersView: View {
    @Bindable var store: StoreOf<BorrowersFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.borrowers) { borrower in
                    Text(borrower.name)
                }
                .onDelete { indexSet in
                    store.$borrowers.withLock {
                    $0.remove(atOffsets: indexSet)
                  }
                }
            }
            .navigationTitle("Borrowers")
            .toolbar {
              ToolbarItem {
                Button {
                  store.send(.addBorrowerButtonTapped)
                } label: {
                  Image(systemName: "plus")
                }
              }
            }
            .sheet(
                item: $store.scope(state: \.destination?.addBorrower, action: \.destination.addBorrower)
            ) { addBorrowerStore in
              NavigationStack {
                  NewBorrowerFormView(store: addBorrowerStore)
                  .navigationTitle("New borrower")
                  .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                      Button("Dismiss") {
                        store.send(.dismissDestinationButtonTapped)
                      }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                      Button("Add") {
                          store.send(.confirmAddBorrowerButtonTapped)
                      }
                    }
                  }
              }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BorrowersView(
            store: Store(initialState: BorrowersFeature.State()) {
                BorrowersFeature()
            }
        )
    }

}

//
//  HomeView.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import ComposableArchitecture
import Sharing
import SwiftUI

@Reducer
struct HomeFeature {

    @Reducer
    enum Destination {
        case addLendedItem(LendItemFormFeature)
    }

    @ObservableState
    struct State {
        @Shared(.fileStorage(.lendedItems)) var lendedItems: [Item] = []
        @Presents var destination: Destination.State?
    }

    enum Action: BindableAction {
        case addLendedItemButtonTapped
        case binding(BindingAction<State>)
        case confirmAddLendedItemButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case dismissDestinationButtonTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .addLendedItemButtonTapped:
                state.destination = .addLendedItem(
                    LendItemFormFeature.State(
                        wipLendItem: Item(name: "")
                    )
                )
                return .none
            case .binding:
                return .none
            case .confirmAddLendedItemButtonTapped:
                guard case let .some(.addLendedItem(lendItemFormFeature)) = state.destination
                else { return .none }

                let newLendedItem = lendItemFormFeature.wipLendItem
                state.$lendedItems.withLock {
                    $0.append(newLendedItem)
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

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.lendedItems) { lendedItem in
                    Text(lendedItem.name)
                }
                .onDelete { indexSet in
                    store.$lendedItems.withLock {
                    $0.remove(atOffsets: indexSet)
                  }
                }
            }
            .navigationTitle("Lend it!")
            .toolbar {
              ToolbarItem {
                Button {
                  store.send(.addLendedItemButtonTapped)
                } label: {
                  Image(systemName: "plus")
                }
              }
            }
            .sheet(
              item: $store.scope(state: \.destination?.addLendedItem, action: \.destination.addLendedItem)
            ) { addLendedItemStore in
              NavigationStack {
                  LendItemFormView(store: addLendedItemStore)
                  .navigationTitle("New lended item")
                  .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                      Button("Dismiss") {
                        store.send(.dismissDestinationButtonTapped)
                      }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                      Button("Add") {
                          store.send(.confirmAddLendedItemButtonTapped)
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
        HomeView(
            store: Store(initialState: HomeFeature.State()) {
                HomeFeature()
            }
        )
    }

}

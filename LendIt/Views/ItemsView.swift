//
//  ItemsView.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import ComposableArchitecture
import Sharing
import SwiftUI

@Reducer
struct ItemsFeature {

    @Reducer
    enum Destination {
        case addItem(NewItemFormFeature)
    }

    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared(.fileStorage(.items)) var items: [Item] = []
    }

    enum Action: BindableAction {
        case addItemButtonTapped
        case binding(BindingAction<State>)
        case confirmAddItemButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case dismissDestinationButtonTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .addItemButtonTapped:
                state.destination = .addItem(
                    NewItemFormFeature.State(
                        wipItem: Item(name: "")
                    )
                )
                return .none
            case .binding:
                return .none
            case .confirmAddItemButtonTapped:
                guard case let .some(.addItem(newItemFormFeature)) = state.destination
                else { return .none }

                let newItem = newItemFormFeature.wipItem
                state.$items.withLock {
                    $0.append(newItem)
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

struct ItemsView: View {
    @Bindable var store: StoreOf<ItemsFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.items) { item in
                    Text(item.name)
                }
                .onDelete { indexSet in
                    store.$items.withLock {
                    $0.remove(atOffsets: indexSet)
                  }
                }
            }
            .navigationTitle("My items")
            .toolbar {
              ToolbarItem {
                Button {
                  store.send(.addItemButtonTapped)
                } label: {
                  Image(systemName: "plus")
                }
              }
            }
            .sheet(
                item: $store.scope(state: \.destination?.addItem, action: \.destination.addItem)
            ) { addItemStore in
              NavigationStack {
                  NewItemFormView(store: addItemStore)
                  .navigationTitle("New item")
                  .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                      Button("Dismiss") {
                        store.send(.dismissDestinationButtonTapped)
                      }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                      Button("Add") {
                          store.send(.confirmAddItemButtonTapped)
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
        ItemsView(
            store: Store(initialState: ItemsFeature.State()) {
                ItemsFeature()
            }
        )
    }

}

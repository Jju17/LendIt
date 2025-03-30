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
        case addLoan(NewLoanFormFeature)
    }

    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared(.fileStorage(.loans)) var loans: [Loan] = []
    }

    enum Action: BindableAction {
        case addLoanButtonTapped
        case binding(BindingAction<State>)
        case confirmAddLoanButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case dismissDestinationButtonTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .addLoanButtonTapped:
                state.destination = .addLoan(
                    NewLoanFormFeature.State(
                        wipLoan: Loan(id: UUID(), name: "", startDate: Date(), endDate: Date().addingTimeInterval(86400))
                    )
                )
                return .none
            case .binding:
                return .none
            case .confirmAddLoanButtonTapped:
                guard case let .some(.addLoan(newLoanFormFeature)) = state.destination
                else { return .none }

                let newLoan = newLoanFormFeature.wipLoan
                state.$loans.withLock {
                    $0.append(newLoan)
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
                ForEach(store.loans) { loan in
                    Text(loan.name)
                }
                .onDelete { indexSet in
                    store.$loans.withLock {
                        $0.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Lend it!")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addLoanButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(
                item: $store.scope(state: \.destination?.addLoan, action: \.destination.addLoan)
            ) { addLoanStore in
                NavigationStack {
                    NewLoanFormView(store: addLoanStore)
                        .navigationTitle("New lended item")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    store.send(.dismissDestinationButtonTapped)
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    store.send(.confirmAddLoanButtonTapped)
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

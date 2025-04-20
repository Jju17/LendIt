//
//  NewLoanForm.swift
//  colockitchenrace
//
//  Created by Julien Rahier on 09/10/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct NewLoanFormFeature {
    @ObservableState
    struct State {
        var wipLoan: Loan
        @Shared(.fileStorage(.borrowers)) var borrowers: [Borrower] = []
        @Shared(.fileStorage(.items)) var items: [Item] = []
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case selectedItemChanged
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .selectedItemChanged:
                if state.wipLoan.name.isEmpty {
                    state.wipLoan.name = "My loan about \(state.wipLoan.itemName)"
                }
                return .none
            }
        }
    }
}

struct NewLoanFormView: View {
    @Bindable var store: StoreOf<NewLoanFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Loan name", text: $store.wipLoan.name)
                Picker("Item to lend", selection: $store.wipLoan.itemName) {
                    ForEach(store.items) {
                        Text($0.name)
                            .tag($0.name)
                    }
                }
                Picker("Borrower", selection: $store.wipLoan.borrowerName) {
                    ForEach(store.borrowers) {
                        Text($0.name)
                            .tag($0.name)
                    }
                }
                GeometryReader { geometry in
                    HStack {
                        Text("Start date")
                        Spacer()
                        HStack(spacing: 0) {
                            Button("Today") { store.wipLoan.startDate = Date() }
                                .buttonStyle(.bordered)
                                .padding(.horizontal, 0)
                            DatePicker(selection: $store.wipLoan.startDate, displayedComponents: .date) {
                                EmptyView()
                            }
                            .padding(.horizontal, 0)
                        }
                        .frame(width: geometry.size.width * 0.6, alignment: .trailing)
                    }
                }
                DatePicker("End date", selection: $store.wipLoan.endDate, in: store.wipLoan.startDate..., displayedComponents: .date)
                TextField("Comment", text: $store.wipLoan.comment, axis: .vertical)
                    .lineLimit(2...8)
            }
        }
        .onChange(of: store.wipLoan.itemName) { oldValue, newValue in
            store.send(.selectedItemChanged)
        }
    }
}

#Preview {
    NewLoanFormView(
        store: Store(
            initialState: NewLoanFormFeature.State(
                wipLoan: Loan(
                    id: UUID(),
                    name: "New loan",
                    borrowerName: "Julien",
                    startDate: Date(),
                    endDate: Date().addingTimeInterval(86400)
                )
            )
        ) {
            NewLoanFormFeature()
        })
}

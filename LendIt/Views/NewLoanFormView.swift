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

struct NewLoanFormView: View {
    @Bindable var store: StoreOf<NewLoanFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Loan name", text: $store.wipLoan.name)
                TextField("Borrower name", text: $store.wipLoan.borrowerName)
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
            }
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
